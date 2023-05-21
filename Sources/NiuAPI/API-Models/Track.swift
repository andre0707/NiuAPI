//
//  Track.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import CoreLocation

/// A single track which was driven.
public struct Track: Codable {
    public let id: Int
    public let trackId: String
    public let startTime: Int
    public let endTime: Int
    /// Traveled distance in meter
    public let distance: Int
    /// Average speed in km/h
    public let avespeed: Double
    /// Riding time in seconds
    public let ridingtime: Int
    public let type: String
    /// The date when the track was recorded. In format yyyymmdd. This is needed when detailed information for this track are needed
    public let date: Int
    public let startPoint: CoordinatePoint
    public let lastPoint: CoordinatePoint
    public let track_thumb: String
    public let power_consumption: Int
    public let meet_count: Int
    public let sn: String
    public let sku_name: String
    public let trackCategory: Int
}


extension Track {
    /// A single coordinate point
    public struct CoordinatePoint: Codable {
        /// Longitude
        public let lng: String
        /// Latitude
        public let lat: String
        
        /// The location object
        public var location: CLLocationCoordinate2D? {
            guard let _lat = Double(lat),
                  let _lon = Double(lng) else { return nil }
            
            return CLLocationCoordinate2D(latitude: _lat, longitude: _lon)
        }
    }
}
