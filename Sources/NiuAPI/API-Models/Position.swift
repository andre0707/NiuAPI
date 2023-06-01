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
    public let longitude: Double
    /// Latitude
    public let latitude: Double
    /// The when the position was recorded
    public let date: Date
    /// Horizontal dilution of precision [0; 50]. A good HDOP is up to 2.5. For navigation a value up to 8 is acceptable.
    public let horizontalDilutionOfPrecision: String
    /// GPS
    public let gps: Int
    /// PGS precision
    public let gpsPrecision: Int
    
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case date = "timestamp"
        case horizontalDilutionOfPrecision = "hdop"
        case gps
        case gpsPrecision
    }
}


extension Position {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Position.CodingKeys> = try decoder.container(keyedBy: Position.CodingKeys.self)
        
        self.longitude = try container.decode(Double.self, forKey: Position.CodingKeys.longitude)
        self.latitude = try container.decode(Double.self, forKey: Position.CodingKeys.latitude)
        
        let _date = try container.decode(Int.self, forKey: Position.CodingKeys.date)
        self.date = Date(timeIntervalSince1970: TimeInterval(_date) / 1000)
        
        self.horizontalDilutionOfPrecision = try container.decode(String.self, forKey: Position.CodingKeys.horizontalDilutionOfPrecision)
        self.gps = try container.decode(Int.self, forKey: Position.CodingKeys.gps)
        self.gpsPrecision = try container.decode(Int.self, forKey: Position.CodingKeys.gpsPrecision)
    }
}
