//
//  ViewController.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 18/03/26.
//

import Cocoa
import Firebase
import GoogleSignIn

class LoginVC: NSViewController, CustomTextFieldDelegate  {
    
    @IBOutlet weak var usernameComponent: NSView!
    @IBOutlet weak var passwordComponent: NSView!
    @IBOutlet weak var usernameTextfield: CustomTextField!
    @IBOutlet weak var passwordTextfield: CustomSecureField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if FirebaseAuthManager.currentUser() != nil {
            self.performSegue(withIdentifier: "splitViewSegue", sender: self)
            
            return
        }
        usernameComponent.wantsLayer = true
        usernameComponent.layer?.cornerRadius = 8
        usernameComponent.layer?.borderWidth = 1
        usernameComponent.layer?.borderColor = NSColor.secondaryLabelColor.cgColor
        
        passwordComponent.wantsLayer = true
        passwordComponent.layer?.cornerRadius = 8
        passwordComponent.layer?.borderWidth = 1
        passwordComponent.layer?.borderColor = NSColor.secondaryLabelColor.cgColor
        
        usernameTextfield.customDelegate = self
        passwordTextfield.customDelegate = self
        usernameTextfield.layer?.borderWidth = 0
        usernameTextfield.focusRingType = .none
        passwordTextfield.focusRingType = .none
        self.view.window?.makeFirstResponder(usernameTextfield)
        _ = usernameTextfield.becomeFirstResponder()
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func didTextFieldSelected(textField: NSTextField) {
        if textField.identifier?.rawValue == "username" {
            usernameComponent.layer?.borderColor = NSColor.systemBlue.cgColor
            passwordComponent.layer?.borderColor = NSColor.secondaryLabelColor.cgColor
        } else {
            passwordComponent.layer?.borderColor = NSColor.systemBlue.cgColor
            usernameComponent.layer?.borderColor = NSColor.secondaryLabelColor.cgColor
        }
    }
    @IBAction func didSelectGoogleLogin(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Error: Firebase clientID not found.")
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self.view.window!
        ) {[weak self] result, error in
            guard error == nil,
            let user = result?.user
            else {
                print("Google Sign-In error: \(error?.localizedDescription ?? "Unknown error")")
                // Handle the error appropriately, e.g., show an alert
                return
            }
            Task {
                do {
                    try await FirebaseAuthManager.signIn(loginInfo: user)
                    self?.performSegue(withIdentifier: "splitViewSegue", sender: self)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
            // The GIDSignInDelegate method in AppDelegate will handle the rest
            // (exchanging Google credentials for Firebase credentials).
            print("Google Sign-In initiated. Delegate will handle result.")
        }
    }
}

protocol CustomTextFieldDelegate: NSTextFieldDelegate {
    func didTextFieldSelected(textField: NSTextField)
}

class CustomTextField: NSTextField {
    var customDelegate: CustomTextFieldDelegate?
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        customDelegate?.didTextFieldSelected(textField: self)
        
        return success
    }
}

class CustomSecureField: NSSecureTextField {
    var customDelegate: CustomTextFieldDelegate?
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        
        customDelegate?.didTextFieldSelected(textField: self)
        return success
    }
}
