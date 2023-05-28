//
//  NetworkConstants.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

struct NetworkConstants {
    static let imageBaseURL = "https://openweathermap.org/img/wn/"
    static let reverseGeocodingURL = "http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&appid=35bd5ff2797113a286b098daa62a8ef1"
    static let cityWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=35bd5ff2797113a286b098daa62a8ef1"
    static let cityCountryWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=%@,%@&appid=35bd5ff2797113a286b098daa62a8ef1"
    static let cityStateCountryWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=%@,%@,%@&appid=35bd5ff2797113a286b098daa62a8ef1"
}
