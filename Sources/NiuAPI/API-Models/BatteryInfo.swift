//
//  BatteryInfo.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// Battery information of a vehicle
public struct BatteryInfo: Codable {
    /// The batteries
    public let batteries: Batteries
    /// Is charging
    public let isCharging: Bool
    /// Centre control battery
    public let centreCtrlBattery: String
    /// Battery detail
    public let batteryDetail: Bool
    /// Estimated mileage in km
    public let estimatedMileage: Int
}


extension BatteryInfo {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<BatteryInfo.CodingKeys> = try decoder.container(keyedBy: BatteryInfo.CodingKeys.self)
        
        self.batteries = try container.decode(BatteryInfo.Batteries.self, forKey: BatteryInfo.CodingKeys.batteries)
        
        let _isCharging =  try container.decode(Int.self, forKey: BatteryInfo.CodingKeys.isCharging)
        self.isCharging = _isCharging == 1
        
        self.centreCtrlBattery = try container.decode(String.self, forKey: BatteryInfo.CodingKeys.centreCtrlBattery)
        self.batteryDetail = try container.decode(Bool.self, forKey: BatteryInfo.CodingKeys.batteryDetail)
        self.estimatedMileage = try container.decode(Int.self, forKey: BatteryInfo.CodingKeys.estimatedMileage)
    }
}


extension BatteryInfo {
    /// A structure for the batteries
    public struct Batteries: Codable {
        /// Battery of compartment A
        public let compartmentA: Compartment
        /// Battery of compartment B
        public let compartmentB: Compartment
    }
}


extension BatteryInfo.Batteries {
    /// A single battery
    public struct Compartment: Codable {
        public let items: [Item]
        public let totalPoint: Int
        /// Battery management identification number
        public let bmsId: String
        /// Is battery connected or not
        public let isConnected: Bool
        /// State of charge in percent
        public let batteryCharging: Int
        /// Charging cycles
        public let chargedTimes: String
        /// Battery temperature in degree celsius
        public let temperature: Int
        /// Battery temperature status
        public let temperatureDesc: String
        /// Energy consumption of today
        public let energyConsumedTody: Int
        /// Battery grade points
        public let gradeBattery: String
    }
}


extension BatteryInfo.Batteries.Compartment {
    public struct Item: Codable {
        public let x: Int
        public let y: Int
        public let z: Int
    }
}
