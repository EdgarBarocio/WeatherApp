//
//  CityGeocode.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

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
