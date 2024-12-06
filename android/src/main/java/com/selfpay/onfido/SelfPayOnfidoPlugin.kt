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

        onfidoWorkflow?.handleActivityResult(1, activity.intent, object : OnfidoWorkflow.ResultListener {
            override fun onUserCompleted() {
                Log.d("OnfidoWorkflow", "Workflow completed successfully.")
                val result = JSObject()
                result.put("status", "success")
                result.put("message", "Workflow completed successfully.")

                call.resolve(result)
            }

            override fun onUserExited(exitCode: ExitCode) {
                Log.d("OnfidoWorkflow", "onUserExited: $exitCode")

                val error = JSObject()
                error.put("status", "error")
                error.put("code", "USEREXITED")
                error.put("exitCode", exitCode.name) // Assuming `exitCode.name` gives a meaningful string

                call.reject("User exited the flow", error)
            }

            override fun onException(exception: OnfidoWorkflow.WorkflowException) {
                val error = JSObject()
                error.put("status", "error")
                error.put("code", "EXCEPTION")
                error.put("message", exception.message)
                call.reject("Onfido flow failed", error)
                exception.printStackTrace()
                Log.d("OnfidoWorkflow", "onException: ${exception.message}")
            }
        })
    }

}
