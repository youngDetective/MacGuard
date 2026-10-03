//
//  TotpVerifier.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/02/26.
//

import Cocoa

class TotpVerifier: NSWindowController {
var mech: TOTPVerifierMechanism?
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.level = .screenSaver
        self.window?.orderFrontRegardless()
        self.window?.isOpaque = false
        self.window?.hasShadow = false
        self.window?.backgroundColor = .clear
        self.window?.titlebarAppearsTransparent = true
        self.window?.isMovable = false
        self.window?.canBecomeVisibleWithoutLogin = true
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    @IBAction func allowLogin(_ sender: Any) {
        mech?.allowLogin()
    }
}
