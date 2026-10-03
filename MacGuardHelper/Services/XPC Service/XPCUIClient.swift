//
//  XPCUIClient.swift
//  MacGuardHelper
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation

class XPCUIClient: NSObject, XPCClient, XPCUIListner {
    
    static let shared = XPCUIClient()
    let bundleID: String = "com.petasos.macGuard"
    var uiAgentList: [pid_t: NSXPCConnection] = [:]
    let codeSigningRequirements: String = """
identifier "com.petasos.macGuard" and anchor apple generic and certificate leaf[subject.CN] = "Apple Development: youngdetective222b@gmail.com (7T9W3UA3C2)" and certificate 1[field.1.2.840.113635.100.6.2.1] /* exists */
"""

    func connect(_ connection: NSXPCConnection) -> Bool {
        uiAgentList[connection.processIdentifier] = connection
        connection.exportedInterface = NSXPCInterface(with: XPCUIListner.self)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCUIClientProtocol.self)
        connection.exportedObject = self
        return true
    }
    
    func ping() {
        print("New XPC connection has been setup")
    }
}
