//
//  OverallTally.swift
//  
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// The overall tally information of a vehicle
public struct OverallTally: Codable {
    /// Bind days count
    public let bindDaysCount: Int
    /// Total driven distance in km
    public let totalMileage: Double
}
