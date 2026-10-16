//
//  KeychainManager.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 03/06/26.
//

import Foundation
import Security

/// A thread-safe utility class for managing Keychain items in iOS/macOS using an Upsert strategy.
class KeychainManager {

    // MARK: - Constants
    
    /// The service name used to identify the keychain items for this app.
    private static let service = Bundle.main.bundleIdentifier ?? "com.myapp.keychain"

    // MARK: - Create / Write (Upsert Pattern)
    
    /// Writes a string value to the Keychain for a specific key.
    /// It attempts to update the item first; if the item doesn't exist, it adds it.
    /// - Parameters:
    ///   - key: The unique identifier for the item.
    ///   - value: The string data to be secured.
    /// - Returns: OSStatus indicating success or failure.
    @discardableResult
    static func save(key: String, value: String) -> OSStatus {
        guard let data = value.data(using: .utf8) else { return errSecParam }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: service,
            kSecAttrLabel as String : key
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        // 1. Try to update the item first
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        // 2. If the item is not found, add it as a new record
        if status == errSecItemNotFound {
            var newQuery = query
            newQuery[kSecValueData as String] = data
            return SecItemAdd(newQuery as CFDictionary, nil)
        }
        
        return status
    }

    // MARK: - Read
    
    /// Reads a string value from the Keychain for a specific key.
    /// - Parameter key: The unique identifier for the item.
    /// - Returns: The stored string if found, otherwise nil.
    static func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: service,
            kSecAttrLabel as String : key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }

    // MARK: - Update
    
    /// Updates an existing value in the Keychain.
    /// - Parameters:
    ///   - key: The identifier for the item to update.
    ///   - value: The new string value.
    /// - Returns: OSStatus indicating success or failure.
    @discardableResult
    static func update(key: String, value: String) -> OSStatus {
        guard let data = value.data(using: .utf8) else { return errSecParam }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: service,
            kSecAttrLabel as String : key
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        return SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    }

    // MARK: - Delete
    
    /// Deletes a specific item from the Keychain.
    /// - Parameter key: The identifier for the item to remove.
    /// - Returns: OSStatus indicating success or failure.
    @discardableResult
    static func delete(key: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: service,
            kSecAttrLabel as String : key
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
}
