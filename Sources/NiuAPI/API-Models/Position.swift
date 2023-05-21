//
//  Position.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import CoreLocation

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
    
    /// The location object
    var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lng)}
}
