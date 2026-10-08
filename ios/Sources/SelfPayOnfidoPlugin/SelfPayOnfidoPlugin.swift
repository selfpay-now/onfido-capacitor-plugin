import Foundation
import Capacitor
import EntrustIdv
import EntrustCaptureAPI
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(SelfPayOnfidoPlugin)
public class SelfPayOnfidoPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SelfPayOnfidoPlugin"
    public let jsName = "SelfPayOnfido"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "startworkflow", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = SelfPayOnfido()
    // Kept alive for the duration of the flow; the SDK does not retain itself.
    private var entrustIdv: EntrustIdv?

    @objc func startworkflow(_ call: CAPPluginCall) {
        guard let sdkToken = call.getString("token"),
              !sdkToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            call.reject("Missing required parameter: 'token'", "missingparameters")
            return
        }

        guard let workflowRunId = call.getString("workflowRunId"),
              !workflowRunId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            call.reject("Missing required parameter: 'workflowRunId'", "missingparameters")
            return
        }

        guard let language = call.getString("language"),
              !language.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            call.reject("Missing required parameter: 'language'", "missingparameters")
            return
        }

        // The Studio SDK token is bound to the workflow run, so the run id is not passed to the SDK.
        CAPLog.print("[EntrustIdvWorkflow] Starting workflow run \(workflowRunId)")

        let parameters = StudioParameters(
            sdkToken: sdkToken,
            configuration: Configuration(
                // Mythril only ships a dark theme
                theme: Theme(mode: .dark),
                localisation: Localisation(language: Self.toLanguageTag(language))
            )
        )

        let callbacks = Callbacks(
            onComplete: { [weak self] _ in
                self?.entrustIdv = nil
                call.resolve([
                    "status": "success",
                    "message": "SDK flow has been completed successfully"
                ])
            },
            onError: { [weak self] error in
                self?.entrustIdv = nil
                let category = String(describing: error.type.category)
                let name = String(describing: error.type)
                CAPLog.print("[EntrustIdvWorkflow] Workflow failed: \(category)/\(name) \(error.message)")
                call.reject("Onfido flow failed", Self.toErrorCode(error.type), nil, [
                    "category": category,
                    "name": name,
                    "message": error.message
                ])
            },
            onUserExit: { [weak self] userAction in
                self?.entrustIdv = nil
                call.reject("User Canceled the flow", Self.toErrorCode(userAction), nil, [
                    "userAction": userAction.rawValue
                ])
            }
        )

        Task { @MainActor [weak self] in
            guard let self = self else { return }
            guard let viewController = self.bridge?.viewController else {
                call.reject("Unable to access the main view controller.")
                return
            }

            // Present modally on iPads, full screen everywhere else.
            let presentationStyle: UIModalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .fullScreen

            let sdk = EntrustIdv(sdkParameters: parameters, callbacks: callbacks)
            self.entrustIdv = sdk
            sdk.start(from: viewController, presentationStyle: presentationStyle)
        }
    }

    /// Mythril sends the Onfido language codes (`en_GB`, `pt_BR`), while the Entrust IDV SDK
    /// ships its translations under lowercase, hyphenated tags (`en-gb`, `pt-br`, `ro`).
    private static func toLanguageTag(_ language: String) -> String {
        language.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "_", with: "-")
            .lowercased()
    }

    /// Maps Entrust IDV error types onto the codes Mythril already handles (OnfidoPluginErrorCode).
    private static func toErrorCode(_ type: IdvErrorType) -> String {
        switch type {
        case .cameraPermissionDenied, .permissionsUnavailable, .cameraNotDetected, .cameraException:
            return "cameraPermission"
        case .microphonePermissionDenied:
            return "microphonePermission"
        case .invalidToken, .expiredToken:
            return "tokenExpired"
        case .sdkVersionInsufficient, .workflowVersionMismatch:
            return "versionInsufficient"
        case .unsupportedError, .unsupportedFeatureError:
            return "workflowUnsupported"
        case .certificatePinningFailed:
            return "invalidSSLCertificate"
        case .apiError, .networkException, .uploadError:
            return "workflowHttpException"
        case .workflowTaskAbandoned:
            return "studioTaskAbandoned"
        case .workflowTaskError:
            return "workflowUnknown"
        case .failedToWriteToDisk:
            return "failedToWriteToDisk"
        case .biometricTokenRetrievalCustomerUserHashMissing,
             .biometricTokenRetrievalEncryptedBiometricTokenNotFound:
            return "tokenRetrievalFailed"
        case .biometricTokenStorageCustomerUserHashMissing,
             .biometricTokenStorageEncryptedBiometricTokenMissing,
             .biometricTokenStorageError:
            return "biometricFailed"
        default:
            return "unknown"
        }
    }

    private static func toErrorCode(_ userAction: UserAction) -> String {
        switch userAction {
        case .permissionsDenied:
            return "cameraPermission"
        case .requiredNFCFlowNotCompleted:
            return "workflowcanceled"
        default:
            return "usercanceledflow"
        }
    }
}
