//
//  WeatherResultsProtocol.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

protocol WeatherResultsProtocolDelegate: AnyObject {
    func displayCurrentWeather(weather: CityWeather)
    func displayImageData(data: Data)
}
