import Foundation
import Capacitor
import Onfido
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

    @objc func startworkflow(_ call: CAPPluginCall) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let sdkToken = call.getString("token"),
                        let workflowRunId = call.getString("workflowRunId") else {
                      call.reject("Missing required parameters: 'sdkToken' or 'workflowRunId'")
                      return
                  }

            let responseHandler: (OnfidoResponse) -> Void = { [weak self] response in
                var errorMessage = "An error occurred during the SDK flow."
                if case let OnfidoResponse.error(error) = response {
                    
                    switch error {
                    case OnfidoFlowError.microphonePermission:
                        call.reject(errorMessage, "microphonePermission", nil, nil)
                        return
                    case OnfidoFlowError.cameraPermission:
                        call.reject(errorMessage, "cameraPermission", nil, nil)
                        return
                    case OnfidoFlowError.failedToWriteToDisk:
                        call.reject(errorMessage, "failedToWriteToDisk", nil, nil)
                        return
                    case OnfidoFlowError.versionInsufficient:
                        call.reject(errorMessage, "versionInsufficient", nil, nil)
                        return
                    case OnfidoFlowError.studioTaskError:
                        call.reject(errorMessage, "studioTaskError", nil, nil)
                        return
                    case OnfidoFlowError.studioTaskAbandoned:
                        call.reject(errorMessage, "studioTaskAbandoned", nil, nil)
                        return
                    default:
                        call.reject(errorMessage, "unknown", nil, nil)
                        return
                    }
                } else if case OnfidoResponse.success = response {
                    let result: [String: Any] = [
                        "status": "success",
                        "message": "SDK flow has been completed successfully"
                    ]
                    call.resolve(result)
                } else if case OnfidoResponse.cancel = response {
                    let result: [String: Any] = [
                        "status": "error",
                        "message": "Flow was canceled by the user"
                    ]
                    call.reject("User Canceled the flow","usercanceledflow", nil, nil)
                }
             }
            
            let workflowConfiguration = WorkflowConfiguration(
                workflowRunId: workflowRunId,
                sdkToken: sdkToken
            )

            // Onfido Studio exposes no `withLocale` on iOS, unlike Android's
            // `WorkflowConfig.Builder.withLocale`, and its `languageCode` argument does not pick the
            // language — the SDK resolves that from the bundle's preferred localizations, i.e. the
            // device language. What it does honour is the *bundle* it reads strings from, so we hand
            // it the SDK's own `<lang>.lproj` directly: every lookup then lands on that language
            // with no resolution step involved.
            if let language = call.getString("language"),
               let localizationBundle = Self.onfidoLocalizationBundle(for: language) {
                workflowConfiguration.withCustomLocalization(
                    withTableName: "Localizable",
                    in: localizationBundle
                )
            }

            let onfidoFlow = OnfidoFlow(workflowConfiguration: workflowConfiguration)
                .with(responseHandler: responseHandler)
            
            do {
                var modalPresentationStyle: UIModalPresentationStyle = .fullScreen
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    modalPresentationStyle = .formSheet // to present modally on iPads
                }
                guard let customerViewController = self.bridge?.viewController else {
                    call.reject("Unable to access the main view controller.")
                    return
                }
            
                try onfidoFlow.run(from: customerViewController, presentationStyle: modalPresentationStyle)
            } catch let error {
            
                call.reject("Starting onfido flow failed")
            }
        }
    }

    /// Onfido publishes one set of language codes (`en_GB`, `zh_CN`, `nb`) but ships the iOS
    /// translations under BCP-47 `.lproj` names (`en-GB`, `zh-Hans`, `no`), so the two only line up
    /// after an underscore swap plus these four renames.
    private static let languageCodeOverrides = [
        "en_US": "en",
        "nb": "no",
        "zh_CN": "zh-Hans",
        "zh_TW": "zh-Hant"
    ]

    /// Returns the SDK's own `<code>.lproj` as a bundle, or `nil` to leave the flow on the device
    /// language. `Bundle(for: OnfidoFlow.self)` must resolve to Onfido.framework — if the SDK is
    /// ever linked statically it becomes the app bundle, no `.lproj` is found, and every flow
    /// silently falls back to the device language.
    private static func onfidoLocalizationBundle(for language: String) -> Bundle? {
        let trimmed = language.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let code = languageCodeOverrides[trimmed] ?? trimmed.replacingOccurrences(of: "_", with: "-")
        guard let lprojPath = Bundle(for: OnfidoFlow.self).path(forResource: code, ofType: "lproj") else {
            return nil
        }

        return Bundle(path: lprojPath)
    }
}
