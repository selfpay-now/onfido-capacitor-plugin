package com.selfpay.onfido

import android.util.Log
import com.entrust.identity.verification.sdk.api.Configuration
import com.entrust.identity.verification.sdk.api.EntrustIDV
import com.entrust.identity.verification.sdk.api.Localisation
import com.entrust.identity.verification.sdk.api.StudioParameters
import com.entrust.identity.verification.sdk.api.callbacks.Callbacks
import com.entrust.identity.verification.sdk.api.callbacks.Error
import com.entrust.identity.verification.sdk.api.callbacks.ErrorType
import com.entrust.identity.verification.sdk.api.callbacks.UserAction
import com.entrust.identity.verification.sdk.api.theming.Theme
import com.entrust.identity.verification.sdk.api.theming.ThemeMode
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin


@CapacitorPlugin(name = "SelfPayOnfido")
class SelfPayOnfidoPlugin : Plugin() {
    private var entrustIdv: EntrustIDV? = null
    private var pendingCall: PluginCall? = null

    /**
     * The ComponentActivity constructor registers an activity result launcher, which is only
     * allowed before the activity is STARTED. Capacitor loads plugins from BridgeActivity.onCreate,
     * so the instance is created here once instead of on every call.
     */
    override fun load() {
        entrustIdv = EntrustIDV(
            activity,
            Callbacks(
                onComplete = { _ -> onComplete() },
                onError = { error -> onError(error) },
                onUserExit = { userAction -> onUserExit(userAction) }
            )
        )
    }

    @PluginMethod
    fun startworkflow(call: PluginCall) {
        val token = call.getString("token")
        val workflowRunId = call.getString("workflowRunId")
        val language = call.getString("language")

        if (token.isNullOrBlank()) {
            call.reject("Missing required parameter: 'token'", "missingparameters")
            return
        }

        if (workflowRunId.isNullOrBlank()) {
            call.reject("Missing required parameter: 'workflowRunId'", "missingparameters")
            return
        }

        if (language.isNullOrBlank()) {
            call.reject("Missing required parameter: 'language'", "missingparameters")
            return
        }

        val sdk = entrustIdv
        if (sdk == null) {
            call.reject("CustomPlugin: Could not initialize the Entrust IDV SDK")
            return
        }

        try {
            // The Studio SDK token is bound to the workflow run, so the run id is not passed to the SDK.
            Log.d(TAG, "Starting workflow run $workflowRunId")
            pendingCall = call
            sdk.start(
                StudioParameters(
                    token,
                    Configuration(
                        // Mythril only ships a dark theme
                        theme = Theme(mode = ThemeMode.Dark),
                        localisation = Localisation(language = toLanguageTag(language))
                    )
                )
            )
        } catch (e: Exception) {
            Log.e(TAG, "Error starting workflow", e)
            pendingCall = null
            call.reject("CustomPlugin: Could not initialize the Entrust IDV SDK")
        }
    }

    /**
     * Mythril sends the Onfido language codes (`en_GB`, `pt_BR`), while the Entrust IDV SDK
     * ships its translations under lowercase, hyphenated tags (`en-gb`, `pt-br`, `ro`).
     */
    private fun toLanguageTag(language: String): String = language.trim().replace('_', '-').lowercase()

    private fun onComplete() {
        Log.d(TAG, "Workflow completed successfully.")
        val result = JSObject()
        result.put("status", "success")
        result.put("message", "Workflow completed successfully.")
        takePendingCall()?.resolve(result)
    }

    private fun onError(error: Error) {
        val type = error.type
        Log.e(TAG, "Workflow failed: ${type.category}/${type.name} ${error.message ?: ""}")

        val data = JSObject()
        data.put("category", type.category.name)
        data.put("name", type.name)
        data.put("message", error.message)

        takePendingCall()?.reject("Onfido flow failed", toErrorCode(type), data)
    }

    private fun onUserExit(userAction: UserAction) {
        Log.d(TAG, "User exited: ${userAction.name}")
        val code = when (userAction) {
            UserAction.PermissionsDenied -> "cameraPermission"
            UserAction.RequiredNfcNotCompleted -> "workflowcanceled"
            else -> "usercanceledflow"
        }

        val data = JSObject()
        data.put("userAction", userAction.name)

        takePendingCall()?.reject("User Canceled the flow", code, data)
    }

    private fun takePendingCall(): PluginCall? {
        val call = pendingCall
        pendingCall = null
        return call
    }

    /** Maps Entrust IDV error types onto the codes Mythril already handles (OnfidoPluginErrorCode). */
    private fun toErrorCode(type: ErrorType): String = when (type) {
        ErrorType.PermissionsUnavailable,
        ErrorType.CameraNotDetected,
        ErrorType.CameraException -> "cameraPermission"
        ErrorType.InvalidToken,
        ErrorType.ExpiredToken -> "tokenExpired"
        ErrorType.SdkVersionInsufficient,
        ErrorType.WorkflowVersionMismatch -> "versionInsufficient"
        ErrorType.UnsupportedError,
        ErrorType.UnsupportedFeatureError -> "workflowUnsupported"
        ErrorType.CertificatePinningFailed -> "invalidSSLCertificate"
        ErrorType.ApiError,
        ErrorType.NetworkException,
        ErrorType.UploadError -> "workflowHttpException"
        ErrorType.WorkflowTaskAbandoned -> "studioTaskAbandoned"
        ErrorType.WorkflowTaskError -> "workflowUnknown"
        ErrorType.BiometricTokenRetrievalCustomerUserHashMissing,
        ErrorType.BiometricTokenRetrievalEncryptedBiometricTokenNotFound -> "tokenRetrievalFailed"
        ErrorType.BiometricTokenStorageCustomerUserHashMissing,
        ErrorType.BiometricTokenStorageEncryptedBiometricTokenMissing,
        ErrorType.BiometricTokenStorageError -> "biometricFailed"
        else -> "unknown"
    }

    companion object {
        private const val TAG = "EntrustIdvWorkflow"
    }
}
