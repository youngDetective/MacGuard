//
//  XPCUIClientManager.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 04/10/26.
//

import Foundation

class XPCUIClientManager: XPCClientManager {
    static let shared = XPCUIClientManager()
    
    override func setInterface(for xpcConnection: NSXPCConnection) {
        let daemonInterface = NSXPCInterface(with: XPCUIListner.self)
        xpcConnection.remoteObjectInterface = daemonInterface
    }
    
    func getProxy() -> XPCUIListner? {
        return xpcConnection.remoteObjectProxyWithErrorHandler { error in
            print("🔴")
        } as? XPCUIListner
    }
    
    override func ping() {
        guard let proxy = getProxy() else {
            print("Pinging Failed")
            return
        }
        proxy.ping()
    }
}
