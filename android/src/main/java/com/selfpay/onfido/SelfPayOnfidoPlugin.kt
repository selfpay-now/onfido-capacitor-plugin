package com.selfpay.onfido

import android.content.Intent
import android.util.Log
import androidx.activity.result.ActivityResult
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.ActivityCallback
import com.getcapacitor.annotation.CapacitorPlugin
import com.onfido.android.sdk.capture.ExitCode
import com.onfido.workflow.OnfidoWorkflow
import com.onfido.workflow.WorkflowConfig


@CapacitorPlugin(name = "SelfPayOnfido")
class SelfPayOnfidoPlugin : Plugin() {
    private final var onfidoWorkflow: OnfidoWorkflow? = null

    @PluginMethod
    fun startworkflow(call: PluginCall) {
        val token = call.getString("token")
        val workflowRunId = call.getString("workflowRunId")
        //todo: throw if any of the above 2 are null or empty
        try {
            val workflowConfig = WorkflowConfig.Builder(
                workflowRunId = workflowRunId!!,
                sdkToken = token!!
            ).build()

            val currentActivity = activity
            this.onfidoWorkflow = OnfidoWorkflow.create(currentActivity)
            startActivityForResult(call, onfidoWorkflow!!.createIntent(workflowConfig), "onfidoFlowFinished");
        }
        catch (e: Exception) {
            Log.e("OnfidoWorkflow", "Error starting workflow", e);
            call.reject("CustomPlugin: Could not initialize the Onfido Workflow")
        }
    }

    @ActivityCallback
    private fun onfidoFlowFinished(call: PluginCall?, result: ActivityResult) {
        if (call == null) {
            return
        }

        onfidoWorkflow?.handleActivityResult(result.resultCode, result.data, object : OnfidoWorkflow.ResultListener {
            override fun onUserCompleted() {
                Log.d("OnfidoWorkflow", "Workflow completed successfully.")
                val result = JSObject()
                result.put("status", "success")
                result.put("message", "Workflow completed successfully.")

                call.resolve(result)
            }

            override fun onUserExited(exitCode: ExitCode) {
                call.reject("User Canceled the flow", "usercanceledflow")
            }

            override fun onException(exception: OnfidoWorkflow.WorkflowException) {
                var code = "unknown"
                when (exception) {
                    is OnfidoWorkflow.WorkflowException.WorkflowInsufficientVersionException ->
                        code = "versionInsufficient";
                    is OnfidoWorkflow.WorkflowException.WorkflowInvalidSSLCertificateException ->
                        code = "invalidSSLCertificate";
                    is OnfidoWorkflow.WorkflowException.WorkflowTokenExpiredException ->
                        code = "tokenExpired";
                    is OnfidoWorkflow.WorkflowException.WorkflowCaptureCancelledException ->
                        code = "workflowcanceled";
                    is OnfidoWorkflow.WorkflowException.WorkflowUnknownCameraException ->
                        code = "cameraPermission";
                    is OnfidoWorkflow.WorkflowException.WorkflowUnknownResultException ->
                        code = "workflowUnknown";
                    is OnfidoWorkflow.WorkflowException.WorkflowUnsupportedTaskException ->
                        code = "workflowUnsuported";
                    is OnfidoWorkflow.WorkflowException.WorkflowHttpException ->
                        code = "workflowhttpexception";
                    is OnfidoWorkflow.WorkflowException.WorkflowUnknownException ->
                        code = "workflowUnknown";
                    is OnfidoWorkflow.WorkflowException.WorkflowAbandonedException ->
                        code = "studioTaskAbandoned";
                    is OnfidoWorkflow.WorkflowException.WorkflowBiometricTokenRetrievalException ->
                        code = "tokenRetrievalFailed";
                    is OnfidoWorkflow.WorkflowException.WorkflowBiometricTokenStorageException ->
                        code = "biometricFailed";
                    else -> code = "unknown"
                }

                call.reject("Onfido flow failed", code)
            }
        })
    }

}
