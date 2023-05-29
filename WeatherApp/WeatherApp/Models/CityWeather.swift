//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

struct CityWeather: Decodable {
    struct main: Decodable {
        var temp: String
        var feelsLike: String
        var tempMin: String
        var tempMax: String
        var humidity: String
        
    }
    
    struct weather: Decodable {
        var icon: String
    }
}
