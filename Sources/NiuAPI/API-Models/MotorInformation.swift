//
//  MotorInformation.swift
//  
//
//  Created by Andre Albach on 21.05.23.
//

import Foundation

/// A motor information object
public struct MotorInformation: Codable {
    /// Status, if the vehicle is currently charging
    public let isCharging: Int
    /// Status, if the vehicle is locked
    public let lockStatus: Int
    /// Status, if the adaptive cruise control is on or not
    public let isAccOn: Int
    /// Status, if fortification is on or not
    public let isFortificationOn: String
    /// Status, if the vehicle is connected or not
    public let isConnected: Bool
    /// The current position of the vehicle
    public let postion: CoordinatePoint
    /// Horizontal dilution of precision [0; 50]. A good HDOP is up to 2.5. For navigation a value up to 8 is acceptable.
    public let hdop: Int
    /// The timestamp (unix time)
    public let time: Int
    /// Information about the batteries
    public let batteries: Battery
    /// The time left to fully charge the battery. Example "1.8" would be 1h48min.
    public let leftTime: String
    /// The estimated milage in km which the vehicle can drive with the current charging state
    public let estimatedMileage: Int
    /// The timestamp (unix time) when the position was recorded
    public let gpsTimestamp: Int
    /// The timestamp (unix time) when the info were recorded
    public let infoTimestamp: Int
    /// The speed in km/h the vehicle is currently driving
    public let nowSpeed: Int
    /// Shaking value
    public let shakingValue: String
    /// Location type
    public let locationType: Int
    /// Battery detail
    public let batteryDetail: Bool
    /// Centre control battery
    public let centreCtrlBattery: Int
    /// The SS protocol version
    public let ss_protocol_ver: Int
    /// The SS online status
    public let ss_online_sta: String
    /// The GPS signal strength
    public let gps: Int
    /// THe GSM signal strength
    public let gsm: Int
    /// Information about the last track
    public let lastTrack: TrackInformation
}

extension MotorInformation {
    /// A single coordinate point
    public struct CoordinatePoint: Codable {
        /// Longitude
        public let lng: Double
        /// Latitude
        public let lat: Double
    }
}

extension MotorInformation {
    /// Battery information
    public struct Battery: Codable {
        /// Battery A
        public let compartmentA: BatteryCompartment
        /// Battery B
        public let compartmentB: BatteryCompartment
    }
}

extension MotorInformation.Battery {
    /// Battery compartment information
    public struct BatteryCompartment: Codable {
        /// The riding time in seconds
        public let bmsId: String
        /// Indicator, if Battery is connected
        public let isConnected: Bool
        /// The percentage of the battery charging level
        public let batteryCharging: Int
        /// The battery health grade. This is a string representation of a percentage.
        public let gradeBattery: String
    }
}

extension MotorInformation {
    /// Basic track information
    public struct TrackInformation: Codable {
        /// The riding time in seconds
        public let ridingTime: Int
        /// The ridden distance in meter
        public let distance: Int
        /// Timestamp when the ride was
        public let time: Int
    }
}
