//
//  DashboardVC.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 11/04/26.
//

import Cocoa

class DashboardVC: NSViewController {
    
    @IBOutlet weak var mfaLabel: NSTextField!
    @IBOutlet weak var status: NSImageView!
    
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var lastLoginLabel: NSTextField!
    
    @IBOutlet weak var accountLinkerBox: NSBox!
    @IBOutlet weak var localAccntLinkerBtn: NSButton!
    
    
    var userInfo: UserInfo?
    
    var localUser = LocalUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FirebaseAuthManager.getUserInfo() {
            setupUser(user: user)
        }
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if localUser.cloudUser == nil {
            accountLinkerBox.isHidden = false
        }
    }
    
    func setupUser(user: UserInfo) {
        self.userInfo = user
        self.userName.stringValue = user.name
        self.email.stringValue = user.email
    }
    
    @IBAction func localAccountLinkerBtnAction(_ sender: NSButton) {
        guard let userInfo else { return }
        DispatchQueue(label: "com.totp.localuser.update").async {
            
            try? self.localUser.updateCloudUser(cloudUserID: userInfo.uid)
            DispatchQueue.main.async {
                if self.localUser.cloudUser != nil {
                    self.accountLinkerBox.isHidden = true
                }
            }
        }
        
    }
    
}
