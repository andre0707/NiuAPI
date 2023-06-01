//
//  BatteryChartData.swift
//  
//
//  Created by Andre Albach on 21.05.23.
//

import Foundation

/// A struct which holds information about the battery chart data
public struct BatteryChartData: Codable {
    /// A list of the data points
    public let items1: [DataPoint]
}


extension BatteryChartData {
    /// A single data point
    public struct DataPoint: Codable {
        /// The milage in km
        public let milage: String
        /// The battery SOC in percentage
        public let batterySOC: String
        
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case milage = "m"
            case batterySOC = "b"
        }
    }
}
