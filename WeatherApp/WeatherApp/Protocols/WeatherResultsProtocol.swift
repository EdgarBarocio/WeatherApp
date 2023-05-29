//
//  WeatherResultsProtocol.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

/// Protocol to pass the result of the weather service call from the View Model to the View
/// and the Weather Icon data from the View Model to the View
protocol WeatherResultsProtocolDelegate: AnyObject {
    func displayCurrentWeather(weather: CityWeather)
    func displayImageData(data: Data)
}
