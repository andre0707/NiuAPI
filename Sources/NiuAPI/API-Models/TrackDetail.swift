//
//  TrackDetail.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// Detail information of a track. This includes the list of coordinates for the route.
public struct TrackDetail: Codable {
    /// A list of all the points which describe the track
    public let trackItems: [TrackPoint]
    /// The start point of the track
    public let startPoint: CoordinatePoint
    /// The end point of the track
    public let lastPoint: CoordinatePoint
    /// The start time of the track
    public let startTime: Date
    /// The end time of the track
    public let lastDate: Date
    //public let meet_list: []
}


extension TrackDetail {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<TrackDetail.CodingKeys> = try decoder.container(keyedBy: TrackDetail.CodingKeys.self)
        
        self.trackItems = try container.decode([TrackPoint].self, forKey: TrackDetail.CodingKeys.trackItems)
        self.startPoint = try container.decode(CoordinatePoint.self, forKey: TrackDetail.CodingKeys.startPoint)
        self.lastPoint = try container.decode(CoordinatePoint.self, forKey: TrackDetail.CodingKeys.lastPoint)
        
        let _startTime = try container.decode(String.self, forKey: TrackDetail.CodingKeys.startTime)
        guard let startTimeTimeInterval = TimeInterval(_startTime) else { throw NiuAPI.Errors.decoding("Invalid start time for TrackDetail") }
        self.startTime = Date(timeIntervalSince1970: startTimeTimeInterval / 1000)
        
        let _lastDate = try container.decode(String.self, forKey: TrackDetail.CodingKeys.lastDate)
        guard let lastDateTimeInterval = TimeInterval(_lastDate) else { throw NiuAPI.Errors.decoding("Invalid last date for TrackDetail") }
        self.lastDate = Date(timeIntervalSince1970: lastDateTimeInterval / 1000)
    }
}


extension TrackDetail {
    /// A single point on the track.
    /// Contains infromation about the location, the date and speed
    public struct TrackPoint: Codable {
        /// Longitude
        public let longitude: Double
        /// Latitude
        public let latitude: Double
        /// Speed in km/h
        public let speed: Int
        /// The date when the point was recorded
        public let date: Date
        /// Acceleration in Y
        public let accelerationY: Int
        /// Acceleration in X
        public let accelerationX: Int
        
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
            case speed
            case date
            case accelerationY = "accelerY"
            case accelerationX = "accelerX"
        }
    }
}


extension TrackDetail.TrackPoint {
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<TrackDetail.TrackPoint.CodingKeys> = try decoder.container(keyedBy: TrackDetail.TrackPoint.CodingKeys.self)
        
        self.latitude = try container.decode(Double.self, forKey: TrackDetail.TrackPoint.CodingKeys.latitude)
        self.longitude = try container.decode(Double.self, forKey: TrackDetail.TrackPoint.CodingKeys.longitude)
        self.speed = try container.decode(Int.self, forKey: TrackDetail.TrackPoint.CodingKeys.speed)
        
        let _date = try container.decode(String.self, forKey: TrackDetail.TrackPoint.CodingKeys.date)
        guard let timeInterval = TimeInterval(_date) else { throw NiuAPI.Errors.decoding("Invalid date for TrackDetail.TrackPoint") }
        self.date = Date(timeIntervalSince1970: timeInterval / 1000)
        
        self.accelerationY = try container.decode(Int.self, forKey: TrackDetail.TrackPoint.CodingKeys.accelerationY)
        self.accelerationX = try container.decode(Int.self, forKey: TrackDetail.TrackPoint.CodingKeys.accelerationX)
    }
}


extension TrackDetail {
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
