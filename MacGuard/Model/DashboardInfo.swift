//
//  DashboardInfo.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 27/03/26.
//

import Foundation

enum DashboardInfo: String, CaseIterable {
    case dashboard = "Dashboard"
    case myDevices = "My Devices"
    case securitySettings = "Security Settings"
    case activityLog = "Activity Log"
    
    var viewControllerSegue: String {
        switch self {
        case .dashboard:
            return "DashboardViewController1"
        case .myDevices:
            return "MyDevicesViewController"
        case .securitySettings:
            return "SecuritySettingsViewController"
        case .activityLog:
            return "ActivityLogViewController"
        }
    }
    
    
}


