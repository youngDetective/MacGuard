//
//  File.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation

class XPCClientManager: NSObject, XPCUIClientProtocol {
    
    let xpcConnection = NSXPCConnection(machServiceName: "com.petasos.macGuard", options: .privileged)
    
    func connect() {
        xpcConnection.invalidationHandler = {
            print("❌ XPC Connection Invalidated: The sandbox blocked lookup, or the daemon is not running.")
        }

        // Triggered if the daemon crashes or rejects the connection
        xpcConnection.interruptionHandler = {
            print("⚠️ XPC Connection Interrupted: The daemon killed the connection or crashed.")
        }
        setInterface(for: xpcConnection)
        xpcConnection.resume()
        ping()
    }
    
    func ping() {}
    
    func setInterface(for xpcConnection: NSXPCConnection) {}
}
