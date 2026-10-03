//
//  TOTPManager.swift
//  totpVerifier
//
//  Created by Jithin Renny Mathew on 18/03/26.
//

import Foundation
import FirebaseAuth
import CoreImage.CIFilterBuiltins
import Cocoa
import CryptoKit

let scale: CGFloat = 10.0
class TOTPManager {
    static func enroll() async throws -> (qrCode: NSImage, Key: String) {
        do {
            guard let user = Auth.auth().currentUser,
                  let email = user.email
            else {
                throw NSError()
            }
            let secret = try generateSecret()
            
            let uri = Self.generateOTPAuthURI(
                secret: secret,  // Base32 encoded secret
                label: email,
                issuer: Bundle.main.bundleIdentifier ?? ""
            )
            guard let data = uri.data(using: .utf8) else {
                throw NSError()
            }
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            filter.message = data
            
            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledImage = outputImage.transformed(by: transform)
                if
                    let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent)
                {
                    
                    return (NSImage(cgImage: cgImage, size: CGSize(width: 100, height: 100)), secret)
                }
            }
            throw NSError()
        } catch {
            print(error)
        }
        throw NSError()
    }
    
    private static func generateOTPAuthURI(
        secret: String,
        label: String,
        issuer: String
    ) -> String {
        // URL encode the label and issuer
        let encodedLabel = label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? label
        let encodedIssuer = issuer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? issuer
        print("otpauth://totp/\(encodedIssuer):\(encodedLabel)?secret=\(secret)&issuer=\(encodedIssuer)")
        return "otpauth://totp/\(encodedIssuer):\(encodedLabel)?secret=\(secret)&issuer=\(encodedIssuer)"
    }
    
    static func verify(code: String, with key: String, for date: Date = Date()) -> Bool {
        // 1. Clean the input code (remove spaces)
        let cleanCode = code.replacingOccurrences(of: " ", with: "")
        guard cleanCode.count == 6, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: cleanCode)) else {
            return false // Fail fast if the code isn't exactly 6 digits
        }
        // 2. Decode your Base32 secret back into raw bytes
        guard let secretBytes = decodeBase32(key) else {
            return false // Fail if the secret is corrupted or invalid Base32
        }
        
        // 3. Get the current 30-second time interval
        let currentTimeSeconds = Int64(date.timeIntervalSince1970)
        let currentStep = currentTimeSeconds / 30
        
        // 4. Check a 3-window range (Previous, Current, Next) to account for slight clock drift
        for windowOffset in -1...1 {
            let stepToCheck = currentStep + Int64(windowOffset)
            
            // Convert time step into an 8-byte big-endian byte array
            var counter = stepToCheck.bigEndian
            let counterData = Data(bytes: &counter, count: MemoryLayout<Int64>.size)
            
            // Compute the HMAC-SHA1 using CryptoKit
            let symmetricKey = SymmetricKey(data: secretBytes)
            let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: symmetricKey)
            let hmacBytes = Array(hmac)
            
            // 5. Dynamic Truncation (Extract 4 bytes from the 20-byte SHA1 hash)
            let offset = Int(hmacBytes.last! & 0x0F)
            let binary = ((Int32(hmacBytes[offset])     & 0x7F) << 24) |
                         ((Int32(hmacBytes[offset + 1]) & 0xFF) << 16) |
                         ((Int32(hmacBytes[offset + 2]) & 0xFF) << 8)  |
                         (Int32(hmacBytes[offset + 3])  & 0xFF)
            
            // 6. Generate the 6-digit string
            let otp = binary % 1_000_000
            let generatedCode = String(format: "%06d", otp)
            // If it matches any window, validation passes
            if generatedCode == cleanCode {
                
                return KeychainManager.save(key: "secureKey", value: key) == errSecSuccess
            }
        }
        
        return false
    }
    
    
    private static func generateSecret() throws -> String {
        var bytes = [UInt8](repeating: 0, count: 20)
        let status = SecRandomCopyBytes(kSecRandomDefault, 20, &bytes)
        
        guard status == errSecSuccess else { throw NSError() }
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        var result = ""
        var bitBuffer: UInt32 = 0
        var bitCount = 0
        
        for byte in bytes {
            bitBuffer = (bitBuffer << 8) | UInt32(byte)
            bitCount += 8
            while bitCount >= 5 {
                let index = Int((bitBuffer >> (bitCount - 5)) & 0x1F)
                result.append(alphabet[alphabet.index(alphabet.startIndex, offsetBy: index)])
                bitCount -= 5
            }
        }
        return result
    }
    
    private static func decodeBase32(_ secret: String) -> Data? {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        let cleanSecret = secret.replacingOccurrences(of: " ", with: "").uppercased()
        
        var bitBuffer: UInt32 = 0
        var bitCount = 0
        var bytes = Data()
        
        for char in cleanSecret {
            guard let value = alphabet.firstIndex(of: char)?.utf16Offset(in: alphabet) else {
                continue // Skip padding characters or invalid text safely
            }
            
            bitBuffer = (bitBuffer << 5) | UInt32(value)
            bitCount += 5
            
            if bitCount >= 8 {
                bitCount -= 8
                let byte = UInt8((bitBuffer >> bitCount) & 0xFF)
                bytes.append(byte)
            }
        }
        
        return bytes.isEmpty ? nil : bytes
    }
    
}
