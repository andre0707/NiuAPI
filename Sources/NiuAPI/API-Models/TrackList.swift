//
//  TrackList.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// A list of tracks
public struct TrackList: Codable {
    /// The track items
    public let items: [Track]
    /// A daily summary for each day which matches a track in `items`
    public let track_mileage: [DaySummary]
}

extension TrackList {
    public struct DaySummary: Codable {
        /// The date in a weird date format. 1st of March 2023 would be: 20230301
        public let date: Int
        /// The total milage for the `date`
        public let mileage: Int
    }
}
