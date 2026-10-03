//
//  ODRecordMapper.swift
//  MacGuard
//
//  Created by Jithin Renny Mathew on 22/09/26.
//

import Foundation
import OpenDirectory

class ODRecordMapper {
    static func getRecordInfo(recordName: String, infoKey: String) -> String? {
        do {
            let session = ODSession.default()
            
            let node = try ODNode(
                session: session,
                name: "/Local/Default"
            )
            
            let record = try node.record(
                withRecordType: kODRecordTypeUsers,
                name: recordName,
                attributes: [infoKey]
            )
            
            let values = try record.values(forAttribute: infoKey)
            
            return values.first as? String
        } catch {
            print(error)
            return nil
        }
    }
    
    static func setRecordAttribute(
        recordName: String,
        infoKey: String,
        value: Any
    ) throws {
        
        let session = ODSession.default()
        
        let node = try ODNode(
            session: session,
            name: "/Local/Default"
        )
        kODNodeTypeLocalNodes
        let record = try node.record(
            withRecordType: kODRecordTypeUsers,
            name: recordName,
            attributes: nil
        )
        
        try record.setValue(value, forAttribute: infoKey)
    }
}
