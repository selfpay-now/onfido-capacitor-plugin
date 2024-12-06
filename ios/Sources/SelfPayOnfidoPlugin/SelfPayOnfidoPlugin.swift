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
                if case let OnfidoResponse.error(error) = response {
                    let errorDetails: [String: Any] = [
                        "status": "error",
                        "message": error.localizedDescription
                    ]
                    call.reject("An error occurred during the SDK flow.")
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
                    call.reject("User Canceled the flow")
                }
             }
            
            let onfidoFlow = OnfidoFlow(workflowConfiguration: .init(
                workflowRunId: workflowRunId,
                sdkToken: sdkToken
            ))
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
            } catch {
                call.reject("Starting onfido flow failed")
            }
        }
    }
}
