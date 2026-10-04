//
//  MacGuardMechanism.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/02/26.
//

import Security
import Foundation
import OpenDirectory

class MacGuardMechanism: NSObject {
    /// A pointer to the MechanismRecord `struct`
    let mech: MechanismRecord?
    /// A convience property to access the `AuthorizationCallbacks` of the Authorization plug-in.
    let mechCallbacks: AuthorizationCallbacks

    /// A convience property to access the `AuthorizationEngineRef` of the Authorization Mechanism.
    let mechEngine: AuthorizationEngineRef
    
    /// Initializer that simply sets up the convience properties to access parts of the authorization plug-in.
    ///
    /// - Parameter mechanism: The base `AuthorizationPlugin` to be used.
    @objc init(mechanism: UnsafePointer<MechanismRecord>) {
        self.mech = mechanism.pointee
        self.mechCallbacks = mechanism.pointee.fPlugin.pointee.fCallbacks.pointee
        self.mechEngine = mechanism.pointee.fEngine
        super.init()
    }
    
    func allowLogin() {
        let error = mechCallbacks.SetResult(mechEngine, .allow)
    }
}
