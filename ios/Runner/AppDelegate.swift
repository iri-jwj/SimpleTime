import UIKit
import Flutter
import MSAL


let au = Authentication.init()
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let oneDriveChannel = FlutterMethodChannel(name: "com.jwj.project_flutter/jump",
                                              binaryMessenger: controller)
    oneDriveChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch(call.method){
        case "connect":
            authenticate(flutterResult : result)
        case "disconnect":
            unAuthenticate(flutterResult: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func authenticate(flutterResult: @escaping FlutterResult){
        au.connectToGraph(scopes: ApplicationConstants.kScopes){
       (result: ApplicationConstants.MSGraphError?, accessToken: String) -> Bool  in
        if let graphError = result {
            switch graphError {
            case .nsErrorType(let nsError):
                print(NSLocalizedString("ERROR", comment: ""), nsError.userInfo)
                flutterResult(FlutterError(code: "connect", message: "Authentication failed: ", details: nil))
            }
            return false
        }
        else {
            // run on main thread!!
            flutterResult(accessToken)
            
            return true
        }
    }
}

private func unAuthenticate(flutterResult: @escaping FlutterResult) {
    
    let result = au.disconnect()
    if result {
        flutterResult("success")
    }else{
        flutterResult("disconnect failed")
    }
}
