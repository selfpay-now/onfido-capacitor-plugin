import Foundation
import Capacitor

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
        let value = call.getString("token") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
