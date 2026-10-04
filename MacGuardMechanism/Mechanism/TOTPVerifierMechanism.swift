//
//  TOTPVerifier.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/02/26.
//

import Foundation
import Cocoa


class TOTPVerifierMechanism: MacGuardMechanism{
    
    @objc func run() {
        NSApp.activate(ignoringOtherApps: true)
        XPCMechanismClientManager.shared.connect()
        allowLogin()
    }
}
