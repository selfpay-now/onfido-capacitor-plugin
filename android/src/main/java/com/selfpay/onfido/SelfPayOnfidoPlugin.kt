package com.selfpay.onfido

import android.util.Log
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.onfido.workflow.OnfidoWorkflow
import com.onfido.workflow.WorkflowConfig

@CapacitorPlugin(name = "SelfPayOnfido")
class SelfPayOnfidoPlugin : Plugin() {

    companion object {
        private const val REQUEST_CODE = 6253465
    }

    @PluginMethod
    fun startworkflow(call: PluginCall) {

        val token = call.getString("token")
        val workflowRunId = call.getString("workflowRunId")

        try {
            val workflowConfig = WorkflowConfig.Builder(
                workflowRunId = workflowRunId!!,
                sdkToken = token!!
            ).build()

            val currentActivity = activity
            val onfidoWorkflow = OnfidoWorkflow.create(currentActivity)
            // Start the workflow
            onfidoWorkflow.startActivityForResult(
                currentActivity,
                1,
                workflowConfig,
            )

        }
        catch (e: Exception) {
            Log.e("OnfidoWorkflow", "Error starting workflow", e)
        }

//        val onfidoWorkflow = OnfidoWorkflow.create(activity)
//        onfidoWorkflow.startActivityForResult(onfidoWorkflow.createIntent(workflowConfig), 1)
    }

}
