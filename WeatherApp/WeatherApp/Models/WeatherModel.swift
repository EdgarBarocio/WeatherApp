//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

struct CityWeather: Codable {
    var currentWeather:Int
    var minTemp:Int
    var maxTemp:Int
    var feelsLikeTemp:Int
    var humidity:Int
    var windSpeed:Double
    var weatherStatus: String
    var weatherDescription: String
    var weatherIcon: String
    
    init(currentWeather: Int, minTemp: Int, maxTemp: Int, feelsLikeTemp: Int, humidity: Int, windSpeed: Double, weatherStatus: String, weatherDescription: String, weatherIcon: String) {
        self.currentWeather = currentWeather
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.feelsLikeTemp = feelsLikeTemp
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.weatherStatus = weatherStatus
        self.weatherDescription = weatherDescription
        self.weatherIcon = weatherIcon
    }
    
    func weatherIconURL() -> URL? {
        return URL(string: <#T##String#>)
    }
}
