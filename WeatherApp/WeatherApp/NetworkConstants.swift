//
//  NetworkConstants.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

struct NetworkConstants {
    static let apiKey = "35bd5ff2797113a286b098daa62a8ef1"
    static let imageBaseURL = "https://openweathermap.org/img/wn/"
    static let reverseGeocodingURL = "http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&appid={API key}"
    static let cityWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}"
    static let cityCountryWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q={city name},{country code}&appid={API key}"
    static let cityStateCountryWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country code}&appid={API key}"
}
