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
    public let isCharging: Bool
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
    public let horizontalDilutionOfPrecision: Int
    /// The date
    public let date: Date
    /// Information about the batteries
    public let batteries: Battery
    /// The time left to fully charge the battery (in minutes)
    public let leftTime: TimeInterval
    /// The estimated milage in km which the vehicle can drive with the current charging state
    public let estimatedMileage: Int
    /// The time when the position was recorded
    public let gpsTimestamp: Date
    /// The time when the info were recorded
    public let infoTimestamp: Date
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
    public let ss_protocolVersion: Int
    /// The SS online status
    public let ss_onlineStatus: String
    /// The GPS signal strength
    public let gps: Int
    /// THe GSM signal strength
    public let gsm: Int
    /// Information about the last track
    public let lastTrack: TrackInformation
    
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        case isCharging
        case lockStatus
        case isAccOn
        case isFortificationOn
        case isConnected
        case postion
        case horizontalDilutionOfPrecision = "hdop"
        case date = "time"
        case batteries
        case leftTime
        case estimatedMileage
        case gpsTimestamp
        case infoTimestamp
        case nowSpeed
        case shakingValue
        case locationType
        case batteryDetail
        case centreCtrlBattery
        case ss_protocolVersion = "ss_protocol_ver"
        case ss_onlineStatus = "ss_online_sta"
        case gps
        case gsm
        case lastTrack
    }
}


extension MotorInformation {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<MotorInformation.CodingKeys> = try decoder.container(keyedBy: MotorInformation.CodingKeys.self)

        let _isCharging = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.isCharging)
        self.isCharging = _isCharging == 1
        
        self.lockStatus = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.lockStatus)
        self.isAccOn = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.isAccOn)
        self.isFortificationOn = try container.decode(String.self, forKey: MotorInformation.CodingKeys.isFortificationOn)
        self.isConnected = try container.decode(Bool.self, forKey: MotorInformation.CodingKeys.isConnected)
        self.postion = try container.decode(MotorInformation.CoordinatePoint.self, forKey: MotorInformation.CodingKeys.postion)
        self.horizontalDilutionOfPrecision = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.horizontalDilutionOfPrecision)
        
        let _date = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.date)
        self.date = Date(timeIntervalSince1970: TimeInterval(_date) / 1000)
        
        self.batteries = try container.decode(MotorInformation.Battery.self, forKey: MotorInformation.CodingKeys.batteries)
        
        let _leftTime: TimeInterval
        if let stringLeftTime = try? container.decodeIfPresent(String.self, forKey: MotorInformation.CodingKeys.leftTime) {
            _leftTime = TimeInterval(stringLeftTime) ?? 0
        } else if let intLeftTime = try? container.decodeIfPresent(Int.self, forKey: MotorInformation.CodingKeys.leftTime) {
            _leftTime = TimeInterval(intLeftTime)
        } else {
            _leftTime = try container.decode(TimeInterval.self, forKey: MotorInformation.CodingKeys.leftTime)
        }
        self.leftTime = _leftTime * 60
        
        self.estimatedMileage = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.estimatedMileage)
        
        let _gpsTimestamp = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.gpsTimestamp)
        self.gpsTimestamp = Date(timeIntervalSince1970: TimeInterval(_gpsTimestamp) / 1000)
        let _infoTimestamp = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.infoTimestamp)
        self.infoTimestamp = Date(timeIntervalSince1970: TimeInterval(_infoTimestamp) / 1000)
        
        self.nowSpeed = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.nowSpeed)
        self.shakingValue = try container.decode(String.self, forKey: MotorInformation.CodingKeys.shakingValue)
        self.locationType = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.locationType)
        self.batteryDetail = try container.decode(Bool.self, forKey: MotorInformation.CodingKeys.batteryDetail)
        self.centreCtrlBattery = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.centreCtrlBattery)
        self.ss_protocolVersion = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.ss_protocolVersion)
        self.ss_onlineStatus = try container.decode(String.self, forKey: MotorInformation.CodingKeys.ss_onlineStatus)
        self.gps = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.gps)
        self.gsm = try container.decode(Int.self, forKey: MotorInformation.CodingKeys.gsm)
        do {
            self.lastTrack = try container.decode(MotorInformation.TrackInformation.self, forKey: MotorInformation.CodingKeys.lastTrack)
        } catch {
            self.lastTrack = .init(ridingTime: 0, distance: 0, time: 0)
        }
    }
}


extension MotorInformation {
    /// A single coordinate point
    public struct CoordinatePoint: Codable {
        /// Longitude
        public let longitude: Double
        /// Latitude
        public let latitude: Double
        
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case longitude = "lng"
            case latitude = "lat"
        }
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
