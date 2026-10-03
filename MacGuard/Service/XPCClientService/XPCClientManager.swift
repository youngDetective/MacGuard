//
//  File.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation

class XPCClientManager: NSObject, XPCUIClientProtocol {
    static let shared = XPCClientManager()
    
    private let xpcConnection = NSXPCConnection(machServiceName: "com.petasos.macGuard", options: .privileged)
    
    func connect() {
        xpcConnection.invalidationHandler = {
            print("❌ XPC Connection Invalidated: The sandbox blocked lookup, or the daemon is not running.")
        }

        // Triggered if the daemon crashes or rejects the connection
        xpcConnection.interruptionHandler = {
            print("⚠️ XPC Connection Interrupted: The daemon killed the connection or crashed.")
        }
        let daemonInterface = NSXPCInterface(with: XPCUIListner.self)
        xpcConnection.remoteObjectInterface = daemonInterface
        xpcConnection.resume()
        ping()
    }
    
    func getProxy() -> XPCUIListner? {
        return xpcConnection.remoteObjectProxyWithErrorHandler { error in
            print("🔴")
        } as? XPCUIListner
    }
    
    func ping() {
        guard let proxy = getProxy() else {
            print("Pinging Failed")
            return
        }
        proxy.ping()
    }
    
}
