//
//  LocationUpdateProtocol.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation
import CoreLocation

protocol CurrentLocationProtocol {
    func updateLocation(location: CLLocation)
}
