//
//  BatteryHealth.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// The battery health structure
public struct BatteryHealth: Codable {
    /// The batteries
    public let batteries: Batteries
    /// Indicator, if the vehicle has one or two batteries
    public let isDoubleBattery: Bool
}


extension BatteryHealth {
    /// A structure for all the batteries
    public struct Batteries: Codable {
        /// Battery A
        public let compartmentA: Compartment
        /// Battery B
        public let compartmentB: Compartment
    }
}


extension BatteryHealth.Batteries {
    /// A description of a single battery.
    public struct Compartment: Codable {
        /// Battery management system identification number
        public let bmsId: String
        /// Indicator, if the battery is connected
        public let isConnected: Bool
        /// THe battery grade points
        public let gradeBattery: String
        /// A list of all the faults
//        public let faults: []
        /// A list of all the health records
        public let healthRecords: [HealthRecord]
    }
}


extension BatteryHealth.Batteries.Compartment {
    /// The structure of a battery health record
    public struct HealthRecord: Codable {
        /// Battery lost grade points
        public let result: String
        /// The amount if charging cycles of the battery
        public let chargeCount: String
        /// HTML color in #RGB format
        public let color: String
        /// Date
        public let date: Date
        /// Name
        public let name: String
        
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case result
            case chargeCount
            case color
            case date = "time"
            case name
        }
    }
}


extension BatteryHealth.Batteries.Compartment.HealthRecord {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys> = try decoder.container(keyedBy: BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys.self)
        
        self.result = try container.decode(String.self, forKey: BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys.result)
        self.chargeCount = try container.decode(String.self, forKey: BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys.chargeCount)
        self.color = try container.decode(String.self, forKey: BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys.color)
        
        let _date = try container.decode(Int.self, forKey: BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys.date)
        self.date = Date(timeIntervalSince1970: TimeInterval(_date) / 1000)
        
        self.name = try container.decode(String.self, forKey: BatteryHealth.Batteries.Compartment.HealthRecord.CodingKeys.name)
    }
}
