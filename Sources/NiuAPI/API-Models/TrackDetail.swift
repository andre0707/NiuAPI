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
    public let startTime: String
    /// The end time of the track
    public let lastDate: String
    //public let meet_list: []
}

extension TrackDetail {
    /// A single point on the track.
    /// Contains infromation about the location, the date and speed
    public struct TrackPoint: Codable {
        /// Longitude
        public let lng: Double
        /// Latitude
        public let lat: Double
        /// Speed in km/h
        public let speed: Int
        /// The date when the point was recorded
        public let date: String
        /// Acceleration in Y
        public let accelerY: Int
        /// Acceleration in X
        public let accelerX: Int
    }
}

extension TrackDetail {
    /// A single coordinate point
    public struct CoordinatePoint: Codable {
        /// Longitude
        public let lng: Double
        /// Latitude
        public let lat: Double
    }
}
