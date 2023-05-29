//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

struct CityWeather {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var description: String
    var iconURL: String
    
    init(temp: Double, feelsLike: Double, tempMin: Double, tempMax: Double, description: String, iconURL: String) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.description = description
        self.iconURL = String(format: NetworkConstants.imageBaseURL, iconURL)
    }
}
