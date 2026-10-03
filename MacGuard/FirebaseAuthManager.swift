//
//  FirebaseAuthManager.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 22/03/26.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

struct FirebaseAuthManager {
    static func signIn(loginInfo: GIDGoogleUser) async throws {
        let signInCredential = GoogleAuthProvider.credential(
            withIDToken: loginInfo.idToken?.tokenString ?? "",
            accessToken: loginInfo.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: signInCredential)
    }
    
    static func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func signOut() throws {
        try Auth.auth().signOut()
    }
    
    static func getUserInfo() -> UserInfo? {
        guard let user = currentUser() else {
            return nil
        }
        let displayName = user.displayName
        let email = user.email
        let photoURL = user.photoURL
        let uid = user.uid
        var icon: NSImage?
        if let url = photoURL {
            icon = NSImage(contentsOf: url)
        }
        return UserInfo(
            name: displayName ?? "",
            email: email ?? "",
            icon: icon,
            uid: uid
        )
    }
}
