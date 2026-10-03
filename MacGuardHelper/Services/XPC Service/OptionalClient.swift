//
//  OptionalClient.swift
//  MacGuardHelper
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation
@objc protocol XPCUIListner: NSObjectProtocol {
    func ping()
}

@objc protocol XPCUIClientProtocol: NSObjectProtocol {
}
