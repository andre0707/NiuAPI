//
//  Vehicle.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// A vehicle a user can have
public struct Vehicle: Codable {
    /// Serial number
    public let sn: String
    public let specialEdition: String
    /// URL to vehicle color image
    public let vehicleColorImg: String
    /// URL to vehicle logo image
    public let vehicleLogoImg: String
    /// Vehicle type id
    public let vehicleTypeId: String
    /// URL to background image
    public let indexHeaderBg: String
    /// URL to vehicle image
    public let scootorImg: String
    /// URL to battery info background image
    public let batteryInfoBg: String
    /// URL to my page header background
    public let myPageHeaderBg: String
    /// URL to scooter list background image
    public let listScooterImg: String
    /// Vehicle name, given by the user
    public let name: String
    /// Vehicle identification number (VIN)
    public let frameNo: String
    /// Engine identification number
    public let engineNo: String
    public let isSelected: Bool
    public let isMaster: Bool
    public let bindNum: Int
    public let renovated: Bool
    public let bindDate: Int
    public let isShow: Bool
    public let isLite: Bool
    /// GPS timestamp in epoch unix timestamp format (13 digits)
    public let gpsTimestamp: Int
    /// Info timestamp in epoch unix timestamp format (13 digits)
    public let infoTimestamp: Int
    /// Product type, e.g. "native"
    public let productType: String
    public let process: String
    public let brand: String
    /// Vehicle has one or two batteries
    public let isDoubleBattery: Bool
    /// List of features
    public let features: [Feature]

    public let permission: Permission
    /// Vehicle model, e.g. "NGT  Black with Red Stripes"
    public let type: String
    
}


extension Vehicle {
    /// A feature which a `Vehicle` han have
    public struct Feature: Codable {
        public let featureName: String
        public let isSupport: Bool
        public let switch_status: String
    }
}

extension Vehicle {
    /// A feature which a `Vehicle` han have
    public struct Permission: Codable {
        public let track: String
        public let dailyStats: String
        public let remote_start: String
    }
}
