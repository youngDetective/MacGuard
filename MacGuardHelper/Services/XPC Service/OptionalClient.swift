//
//  OptionalClient.swift
//  MacGuardHelper
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation
@objc protocol XPCUIListner: NSObjectProtocol {
    func ping()
    func updateCloudUser(cloudUserID: String, username: String) async -> Bool
}

@objc protocol XPCUIClientProtocol: NSObjectProtocol {
}

@objc protocol XPCMechanismListner: NSObjectProtocol {
    func ping()
}
