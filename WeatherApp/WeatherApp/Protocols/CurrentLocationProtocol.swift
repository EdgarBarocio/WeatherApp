//
//  LocationUpdateProtocol.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation
import CoreLocation

/// Protocol to pass the CityGeocode struct from the View Model to the View
protocol CurrentLocationProtocol: AnyObject {
    func updateLocation(location: CityGeocode)
}
