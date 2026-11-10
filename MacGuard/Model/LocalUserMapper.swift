//
//  LocalUserMapper.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/09/26.
//

import Foundation

class LocalUser {
    private(set) var cloudUser = ODRecordMapper.getRecordInfo(
        recordName: NSUserName(),
        infoKey: "linkedAccountId"
    )
    
    func updateCloudUser(cloudUserID: String) async -> Bool {
        if await XPCUIClientManager.shared.updateCloudUser(
            cloudUserID: cloudUserID
        ) {
            cloudUser = cloudUserID
            return true
        }
        return false
    }
}
