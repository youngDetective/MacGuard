//
//  SMAppServiceRegister.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 03/10/26.
//

import Foundation
import ServiceManagement

final class DaemonServiceManager {
    private static let service = SMAppService.daemon(plistName: "com.petasos.MacGuard.daemon.plist")

    static var status: SMAppService.Status { service.status }

    static func register() throws {
        switch service.status {
        case .enabled:
            return
        case .requiresApproval:
            SMAppService.openSystemSettingsLoginItems()
            throw DaemonServiceError.requiresApproval
        case .notRegistered, .notFound:
            try service.register()
        @unknown default:
            try service.register()
        }
    }

    static func unregister() throws {
        try service.unregister()
    }
}

enum DaemonServiceError: LocalizedError {
    case requiresApproval

    var errorDescription: String? {
        switch self {
        case .requiresApproval:
            return "Enable MacGuard Daemon in System Settings → General → Login Items & Extensions."
        }
    }
}

