//
//  ServiceCalls.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

class ServiceCalls {
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var weather: CityWeather?
    
    typealias WeatherResult = (CityWeather?, String) -> Void
    
    func getWeatherResults(url: URL, completion: @escaping WeatherResult) {
        dataTask?.cancel()
        
        dataTask?.resume()
    }
}
