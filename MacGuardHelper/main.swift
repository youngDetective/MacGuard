//
//  main.swift
//  MacGuardHelper
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation


let delegate = XPCListnerDelegate()
let listener = NSXPCListener(machServiceName: "com.petasos.macGuard")
listener.delegate = delegate
Logger.authentication.info("retriyingzzz")
listener.resume()

import Foundation
import OSLog

extension Logger {
    // 1. Automatically fetch the bundle identifier to use as the subsystem
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.petasos.macGuardHelper"

    // 2. Define categories for different modules
    static let ui = Logger(subsystem: subsystem, category: "UI")
    static let network = Logger(subsystem: subsystem, category: "Network")
    static let database = Logger(subsystem: subsystem, category: "Database")
    static let authentication = Logger(subsystem: subsystem, category: "Auth")
}

dispatchMain()
