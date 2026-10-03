//
//  TOTPEnroller.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 26/04/26.
//

import Cocoa

class TOTPEnroller: NSViewController {
    @IBOutlet weak var QRCode: NSImageView!
    @IBOutlet weak var otpField: NSTextField!
    
    var secret: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        Task {
            do {
                let (image, secret) = try await TOTPManager.enroll()
                QRCode.image = image
                self.secret = secret
            } catch {
                let alert = NSAlert(error: error)
                alert.runModal()
            }
        }
    }
    @IBAction func validateTOTP(_ sender: Any) {
        guard let secret else { return }
        TOTPManager.verify(code: otpField.stringValue, with: secret)
    }
    
}
