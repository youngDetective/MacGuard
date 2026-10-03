//
//  XPCClient.swift
//  MacGuardHelper
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation
protocol XPCClient {
    var bundleID: String { get }
    func connect(_ connection: NSXPCConnection) -> Bool
    var codeSigningRequirements: String { get }
}
