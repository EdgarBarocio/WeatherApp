//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

class CityWeatherViewModel {
    
    
    func searchParameters(city: CityGeocode) -> String {
        var searchString = city.name
        
        if let state = city.state {
            searchString.append(",\(state)")
        }

        if let country = city.country {
            searchString.append(",\(country)")
        }

        return searchString
    }
}
