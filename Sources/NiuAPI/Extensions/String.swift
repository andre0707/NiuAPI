//
//  String.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import CryptoKit

internal extension String {
    /// The md5 hash of `self`
    var md5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
