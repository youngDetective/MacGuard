//
//  UserInfo.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 28/03/26.
//

import Foundation
import Cocoa

struct UserInfo {
    var name: String
    var email: String
    var icon: NSImage?
    var uid: String
    func signOut() throws {
        try DispatchQueue(label: "").sync {
            try FirebaseAuthManager.signOut()
        }
    }
}
