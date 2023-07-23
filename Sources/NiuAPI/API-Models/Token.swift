//
//  Token.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// A token object which contains information about access and refresh token
public struct Token: Codable {
    /// The access token
    public let access_token: String
    /// The refresh token
    public let refresh_token: String
    /// Time interval when the refresh token will expire
    public let refresh_token_expires_in: Int
    /// Time interval when the access token will expire
    public let token_expires_in: Int
    
    /// The token expiration date
    public var tokenExpirationDate: Date { Date(timeIntervalSince1970: TimeInterval(refresh_token_expires_in)) }
}
