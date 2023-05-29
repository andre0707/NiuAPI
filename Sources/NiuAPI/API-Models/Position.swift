//
//  Position.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// The position data of a vehicle
public struct Position: Codable {
    /// Longitude
    public let lng: Double
    /// Latitude
    public let lat: Double
    /// The timestamp (unix time) when the position was recorded
    public let timestamp: Int
    /// Horizontal dilution of precision [0; 50]. A good HDOP is up to 2.5. For navigation a value up to 8 is acceptable.
    public let hdop: String
    /// GPS
    public let gps: Int
    /// PGS precision
    public let gpsPrecision: Int
}


// MARK: - Computed properties for easier handling

extension Position {
    /// The `Date` object version of `self.time`.
    public var date: Date { Date(timeIntervalSince1970: TimeInterval(timestamp / 1000)) }
}
