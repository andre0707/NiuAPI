//
//  User.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// User information coming from the API
public struct User: Codable {
    public let user_id: String
    public let mobile: String
    public let email: String
    public let country_code: String
    public let nick_name: String
    public let real_name: String
    public let last_name: String
    public let identification_code: String
    public let birthdate: String
    public let gender: Int
    public let avatar: String
    public let thumb_avatar: String
    public let profession: Int
    public let income: Int
    public let car_owners: Int
    public let purpose: String
    public let sign: String
    public let background: String
    public let height: Int
    public let weight: Int
}
