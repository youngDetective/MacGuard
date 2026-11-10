//
//  XPCMechanismClient.swift
//  MacGuardMechanism
//
//  Created by Jithin Renny Mathew on 04/10/26.
//

import Foundation

import Foundation

class XPCMechanismClientManager: XPCClientManager {
    static let shared = XPCMechanismClientManager()
    
    override func setInterface(for xpcConnection: NSXPCConnection) {
        let daemonInterface = NSXPCInterface(with: XPCMechanismListner.self)
        xpcConnection.remoteObjectInterface = daemonInterface
    }
    
    func getProxy() -> XPCMechanismListner? {
        return xpcConnection.remoteObjectProxyWithErrorHandler { error in
            print("🔴")
        } as? XPCMechanismListner
    }
    
    override func ping() {
        guard let proxy = getProxy() else {
            print("Pinging Failed")
            return
        }
        proxy.ping()
    }
}
