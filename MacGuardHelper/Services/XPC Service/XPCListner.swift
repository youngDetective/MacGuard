//
//  XPCListner.swift
//  MacGuardHelper
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation
import Security
import OSLog

class XPCListnerDelegate: NSObject, NSXPCListenerDelegate {
    
    var mappedClients: [String: XPCClient] = [
        XPCUIClient.shared.bundleID: XPCUIClient.shared
    ]
    
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        
        guard let bundleID = getBundleIdentifier(forPID: newConnection.processIdentifier),
            let client = mappedClients[bundleID],
              client.connect(newConnection)
        else {
            return false
        }
        newConnection.setCodeSigningRequirement(client.codeSigningRequirements)
        newConnection.resume()
        return true
    }
    
    func getBundleIdentifier(forPID pid: pid_t) -> String? {
        let codeSignInfo = getCodeSigningInfo(forPID: pid)
        return codeSignInfo?[kSecCodeInfoIdentifier as String] as? String
    }
    
    func getCodeSigningInfo(forPID pid: pid_t) -> [String: Any]? {
        var attributes: [CFString: Any] = [
            kSecGuestAttributePid: NSNumber(value: pid)
        ]
        var code: SecCode?
        let status = SecCodeCopyGuestWithAttributes(nil, attributes as CFDictionary, [], &code)
        guard status == errSecSuccess, let code = code else { return nil }

        var signingInfo: CFDictionary?
        var staticCode: SecStaticCode?
            
            // Call the Security framework function
            let codeSwapperStatus = SecCodeCopyStaticCode(code, SecCSFlags(rawValue: 0), &staticCode)
        let infoStatus = SecCodeCopySigningInformation(staticCode!, SecCSFlags(), &signingInfo)
        guard infoStatus == errSecSuccess, let info = signingInfo as? [String: Any] else { return nil }
        
        return info
    }
}
