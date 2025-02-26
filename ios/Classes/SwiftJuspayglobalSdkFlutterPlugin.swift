/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Flutter
import UIKit
import GlobalJuspayPaymentsSDK

public class SwiftJuspayglobalSdkFlutterPlugin: NSObject, FlutterPlugin {
    private static var CHANNEL_NAME = "juspayglobalPaymentsSDK"
    private let juspayglobalChannel: FlutterMethodChannel
    private lazy var juspayglobalServices: GlobalJuspayPaymentsServices = {
        return GlobalJuspayPaymentsServices()
    }()
    private let hyperViewController = UIViewController()

    init(_ channel: FlutterMethodChannel, _ registrar: FlutterPluginRegistrar) {
        juspayglobalChannel = channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftJuspayglobalSdkFlutterPlugin(channel, registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
        let factory = JuspayglobalPlatformViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "HyperSdkViewGroup")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "preFetch":
            let args = call.arguments as! Dictionary<String, Any>
            preFetch(args["params"] as! [String: Any], result)
        case "initiate":
            let args = call.arguments as! Dictionary<String, Any>
            initiate(args["params"] as! [String: Any], result)
        case "openPaymentPage":
            let args = call.arguments as! Dictionary<String, Any>
            openPaymentPage(args["params"] as! [String: Any], result)
        case "process":
            let args = call.arguments as! Dictionary<String, Any>
            process(args["params"] as! [String: Any], result)
        case "processWithView":
            let args = call.arguments as! Dictionary<String, Any>
            processWithView(args["viewId"] as! Int, args["params"] as! [String: Any], result)
        case "terminate": terminate(result)
        case "isInitialised": isInitialised(result)
        default: result(FlutterMethodNotImplemented)
        }
    }

    private func isInitialised(_ result: @escaping FlutterResult) {
        result(juspayglobalServices.isInitialised())
    }

    private func preFetch(_ params: [String: Any], _ result: @escaping FlutterResult) {
        HyperServices.preFetch(params)
        result(true)
    }

    private func initiate(_ params: [String: Any], _ result: @escaping FlutterResult) {
        hyperViewController.modalPresentationStyle = .overFullScreen
        juspayglobalServices.initiate(hyperViewController, payload: params, callback: { [unowned self] (response) in
            if response == nil {
                return
            }

            let event = response!["event"] as? String ?? ""

            if let jsonData = try? JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    self.juspayglobalChannel.invokeMethod(event, arguments: jsonString)
                }
            }
        })
        result(true)
    }

    private func process(_ params: [String: Any], _ result: @escaping FlutterResult) {
        if (self.juspayglobalServices.isInitialised()) {
            if let topViewController = (UIApplication.shared.delegate?.window??.rootViewController) {
                self.juspayglobalServices.baseViewController = topViewController
                self.juspayglobalServices.shouldUseViewController = true
                self.juspayglobalServices.process(params)
            } else {
                result(false)
                return
            }
        } else {
            result(false)
            return
        }
        result(true)
    }

    private func processWithView(_ viewId: Int, _ params: [String: Any], _ result: @escaping FlutterResult) {
        if let topViewController = (UIApplication.shared.delegate?.window??.rootViewController) {
            self.juspayglobalServices.baseViewController = topViewController
            if let uiView = topViewController.view.viewWithTag(viewId) {
                self.juspayglobalServices.baseViewController = topViewController
                self.juspayglobalServices.shouldUseViewController = false
                self.juspayglobalServices.baseView = uiView
                self.juspayglobalServices.process(params)
            } else {
                result(false)
                return
            }
        } else {
            result(false)
            return
        }
        result(true)
    }

    private func openPaymentPage(_ params: [String: Any], _ result: @escaping FlutterResult) {
        if let topViewController = (UIApplication.shared.delegate?.window??.rootViewController) {
            HyperCheckoutLite.openPaymentPage(topViewController, payload: params, callback: { [unowned self] (response) in
                guard let response = response else {
                    return
                }
                let event = response["event"] as? String ?? ""

                if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        self.juspayglobalChannel.invokeMethod(event, arguments: jsonString)
                    }
                }
            })
            result(true)
        } else {
            result(false)
        }
    }

    private func terminate(_ result: @escaping FlutterResult) {
        juspayglobalServices.terminate()
        result(true)
    }
}
