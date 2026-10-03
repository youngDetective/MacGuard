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
    override init() {
        FirebaseApp.configure()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
 
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

