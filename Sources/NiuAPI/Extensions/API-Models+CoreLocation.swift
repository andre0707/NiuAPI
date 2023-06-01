//
//  API-Models+CoreLocation.swift
//  
//
//  Created by Andre Albach on 21.05.23.
//

#if canImport(CoreLocation)
import CoreLocation

extension MotorInformation.CoordinatePoint {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

extension Position {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude)}
}

extension Track.CoordinatePoint {
    /// The location object
    public var location: CLLocationCoordinate2D? { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

extension TrackDetail.TrackPoint {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

extension TrackDetail.CoordinatePoint {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

#endif
