//
//  LoginResponse.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// A response object when logging in with the account
public struct LoginResponse: Codable {
    /// Token information
    public let token: Token
    /// User information
    public let user: User
}
