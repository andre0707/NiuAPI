//
//  Track.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// A single track which was driven.
public struct Track: Codable {
    public let id: Int
    public let trackId: String
    public let startTime: Date
    public let endTime: Date
    /// Traveled distance in meter
    public let distance: Int
    /// Average speed in km/h
    public let averageSpeed: Double
    /// Riding time in seconds
    public let ridingTime: Int
    public let type: String
    /// The date when the track was recorded. In format yyyymmdd. This is needed when detailed information for this track are needed
    public let date: Int
    public let startPoint: CoordinatePoint
    public let lastPoint: CoordinatePoint
    public let trackThumbnail: String
    public let powerConsumption: Int
    public let meetCount: Int
    public let sn: String
    public let skuName: String
    public let trackCategory: Int
    
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        case id
        case trackId
        case startTime
        case endTime
        case distance
        case averageSpeed = "avespeed"
        case ridingTime = "ridingtime"
        case type
        case date
        case startPoint
        case lastPoint
        case trackThumbnail = "track_thumb"
        case powerConsumption = "power_consumption"
        case meetCount = "meet_count"
        case sn
        case skuName = "sku_name"
        case trackCategory
    }
}


extension Track {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Track.CodingKeys> = try decoder.container(keyedBy: Track.CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: Track.CodingKeys.id)
        self.trackId = try container.decode(String.self, forKey: Track.CodingKeys.trackId)
        
        let _startTime = try container.decode(Int.self, forKey: Track.CodingKeys.startTime)
        self.startTime = Date(timeIntervalSince1970: TimeInterval(_startTime) / 1000)
        
        let _endTime = try container.decode(Int.self, forKey: Track.CodingKeys.endTime)
        self.endTime = Date(timeIntervalSince1970: TimeInterval(_endTime) / 1000)
        
        self.distance = try container.decode(Int.self, forKey: Track.CodingKeys.distance)
        self.averageSpeed = try container.decode(Double.self, forKey: Track.CodingKeys.averageSpeed)
        self.ridingTime = try container.decode(Int.self, forKey: Track.CodingKeys.ridingTime)
        self.type = try container.decode(String.self, forKey: Track.CodingKeys.type)
        self.date = try container.decode(Int.self, forKey: Track.CodingKeys.date)
        self.startPoint = try container.decode(Track.CoordinatePoint.self, forKey: Track.CodingKeys.startPoint)
        self.lastPoint = try container.decode(Track.CoordinatePoint.self, forKey: Track.CodingKeys.lastPoint)
        self.trackThumbnail = try container.decode(String.self, forKey: Track.CodingKeys.trackThumbnail)
        self.powerConsumption = try container.decode(Int.self, forKey: Track.CodingKeys.powerConsumption)
        self.meetCount = try container.decode(Int.self, forKey: Track.CodingKeys.meetCount)
        self.sn = try container.decode(String.self, forKey: Track.CodingKeys.sn)
        self.skuName = try container.decode(String.self, forKey: Track.CodingKeys.skuName)
        self.trackCategory = try container.decode(Int.self, forKey: Track.CodingKeys.trackCategory)
    }
}


extension Track {
    /// A single coordinate point
    public struct CoordinatePoint: Codable {
        /// Longitude
        public let longitude: Double
        /// Latitude
        public let latitude: Double
        
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
}


extension Track.CoordinatePoint {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Track.CoordinatePoint.CodingKeys> = try decoder.container(keyedBy: Track.CoordinatePoint.CodingKeys.self)
        
        let _lon = try container.decode(String.self, forKey: Track.CoordinatePoint.CodingKeys.longitude)
        let _lat = try container.decode(String.self, forKey: Track.CoordinatePoint.CodingKeys.latitude)
        guard let _longitude = Double(_lon) else { throw NiuAPI.Errors.decoding("Invalid longitude in Track.CoordinatePoint") }
        guard let _latitude = Double(_lat) else { throw NiuAPI.Errors.decoding("Invalid latitude in Track.CoordinatePoint") }
        
        self.longitude = _longitude
        self.latitude = _latitude
    }
}
