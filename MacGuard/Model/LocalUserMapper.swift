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
    
    func updateCloudUser(cloudUserID: String) throws {
        try ODRecordMapper.setRecordAttribute(
            recordName: NSUserName(),
            infoKey: "linkedAccountId",
            value: cloudUserID
        )
        cloudUser = cloudUserID
    }
}
