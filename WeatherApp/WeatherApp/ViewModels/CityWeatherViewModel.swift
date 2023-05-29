//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation
import UIKit
import CoreLocation

class CityWeatherViewModel {
    
    private var serviceCalls = ServiceCalls()
    private var weather: CityWeather?
    
    weak var delegate: (WeatherResultsProtocolDelegate)?
    weak var locationDelegate: (CurrentLocationProtocol)?
    
    func performSearch(entry: String) {
        let searchArray = entry.components(separatedBy: [","]).filter({!$0.isEmpty})

        //let searchArray = entry.split(separator: ",", omittingEmptySubsequences: true)
        let city = createCityGeocode(searchArray)
        let searchURL = searchParameters(city: city)
        
        if let safeURL = searchURL {
            serviceCalls.getWeatherResults(url: safeURL) {[weak self] result, errorMessage in
                self?.parseResponse(data: result, errorMessage: errorMessage)
            }
        }
    }
    
    func getImagefromURL(url: String) {
        serviceCalls.downloadImage(url: url) { [weak self] result in
            self?.delegate?.displayImageData(data: result)
        }
    }
    
    func getCityFromLocation(location: CLLocation?) {
        
        guard let safeLocation = location else { return }
        
        let geocodeString = String(format: NetworkConstants.reverseGeocodingURL, safeLocation.coordinate.latitude, safeLocation.coordinate.longitude)
        let geocodeURL = URL(string: geocodeString)
        
        if let safeURL = geocodeURL {
            serviceCalls.getCity(url: safeURL) { [weak self] result, errorMessage in
                self?.parseGeolocation(data: result, errorMessage: errorMessage)
            }
        }
    }
    
    //MARK: - Private Functions
    
    private func searchParameters(city: CityGeocode?) -> URL? {
        guard let safeCity = city else { return nil }
        
        var searchString = safeCity.name
        
        if let state = safeCity.state?.replacingOccurrences(of: " ", with: "") {
            searchString.append(",\(state)")
        }

        if let country = safeCity.country?.replacingOccurrences(of: " ", with: "") {
            searchString.append(",\(country)")
        }
        let encodedString = searchString.replacingOccurrences(of: " ", with: "%20")
        let urlString = String(format: NetworkConstants.cityWeatherURL, encodedString)
        return URL(string: urlString)
    }
    
    private func createCityGeocode(_ parameters:[String] ) -> CityGeocode? {
    
        if parameters.count == 1 {
            return CityGeocode(name: parameters[0])
        } else if parameters.count == 2 {
            return CityGeocode(name: parameters[0], country: parameters[1])
        } else if parameters.count == 3 {
            return CityGeocode(name: parameters[0], state: parameters[1], country: parameters[2])
        }
        
        return nil
    }
    
    private func parseResponse(data: Data, errorMessage: String) {
        var responseDictionary: [String: Any]?
        
        do {
            responseDictionary = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any] ?? Dictionary()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let weatherArray = responseDictionary?["weather"] as? [Any],
              let weatherDictionary = weatherArray.first as? [String: Any],
              let mainDictionary = responseDictionary?["main"] as? [String: Any] else {
            return
        }

        let cityWeather = CityWeather(temp: mainDictionary["temp"] as? Double ?? 0.0,
                                      feelsLike: mainDictionary["feels_like"] as? Double ?? 0.0,
                                      tempMin: mainDictionary["temp_min"] as? Double ?? 0.0,
                                      tempMax: mainDictionary["temp_max"] as? Double ?? 0.0,
                                      description: weatherDictionary["description"] as? String ?? "nope",
                                      iconURL: weatherDictionary["icon"] as? String ?? "nope")
        
        delegate?.displayCurrentWeather(weather: cityWeather)
    }
    
    private func parseGeolocation(data: Data, errorMessage: String) {
        var responseDictionary: [String: Any]?
        
        do {
            let str = String(decoding: data, as: UTF8.self)
            let dropFirst = str.dropFirst()
            let cleanString = dropFirst.dropLast()
            let cleanData = Data(cleanString.utf8)
            responseDictionary = try JSONSerialization.jsonObject(with: cleanData, options:[]) as? [String: Any] ?? Dictionary()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let namesDictionary = responseDictionary?["local_names"] as? [String: Any],
            let name = namesDictionary["en"] as? String else {
                return
                
            }
        
        let cityGeocode: CityGeocode = CityGeocode(name: name)
        locationDelegate?.updateLocation(location: cityGeocode)
    }
}
