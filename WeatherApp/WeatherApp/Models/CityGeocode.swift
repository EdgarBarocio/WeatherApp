//
//  CityGeocode.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

/// Struct to store reverse geocode location and to have a struct to format the Weather search URL to account
/// for the three call combinatinos.l
struct CityGeocode {
    var name: String
    var state: String?
    var country: String?
    
    init(name: String, state: String? = nil, country: String? = nil) {
        self.name = name
        self.state = state
        self.country = country
    }
}
