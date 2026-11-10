//
//  AppDelegate.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 18/03/26.
//

import Cocoa
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()
        do {
           try DaemonServiceManager.register()
           XPCUIClientManager.shared.connect()
        } catch {
            print(error)
        }
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func codeSigningInfo(forPID pid: pid_t) -> [String: Any]? {
        var attributes: [CFString: Any] = [
            kSecGuestAttributePid: NSNumber(value: pid)
        ]
        var code: SecCode?
        let status = SecCodeCopyGuestWithAttributes(nil, attributes as CFDictionary, [], &code)
        guard status == errSecSuccess, let code = code else { return nil }

        var signingInfo: CFDictionary?
        var staticCode: SecStaticCode?
            
            // Call the Security framework function
            let codeSwapperStatus = SecCodeCopyStaticCode(code, SecCSFlags(rawValue: 0), &staticCode)
        let infoStatus = SecCodeCopySigningInformation(staticCode!, SecCSFlags(), &signingInfo)
        guard infoStatus == errSecSuccess, let info = signingInfo as? [String: Any] else { return nil }
        
        return info
    }
}

