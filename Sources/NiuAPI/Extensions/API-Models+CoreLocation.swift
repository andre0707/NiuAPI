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
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lng) }
}

extension Position {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lng)}
}

extension Track.CoordinatePoint {
    /// The location object
    public var location: CLLocationCoordinate2D? {
        guard let _lat = Double(lat),
              let _lon = Double(lng) else { return nil }
        
        return CLLocationCoordinate2D(latitude: _lat, longitude: _lon)
    }
}

extension TrackDetail.TrackPoint {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lng) }
}

extension TrackDetail.CoordinatePoint {
    /// The location object
    public var location: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lng) }
}

#endif
