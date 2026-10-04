//
//  TOTPVerifier.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/02/26.
//

import Foundation
import Cocoa


class TOTPVerifierMechanism: MacGuardMechanism{
    @objc var viewController: TotpVerifier?
    
    @objc func run() {
        NSApp.activate(ignoringOtherApps: true)
        viewController = TotpVerifier(windowNibName: NSNib.Name("TotpVerifier"))
        viewController?.mech = self
        if viewController == nil {
            FileManager.default.createFile(atPath: "/Users/Shared/k", contents: nil)
            allowLogin()
            return
        }
        FileManager.default.createFile(atPath: "/Users/Shared/kk", contents: nil)
        NSApp.runModal(for: viewController!.window!)
    }
}
