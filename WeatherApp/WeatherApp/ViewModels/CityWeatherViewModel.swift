//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation
import UIKit

class CityWeatherViewModel {
    
    private var serviceCalls = ServiceCalls()
    private var weather: CityWeather?
    
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
    
    //MARK: - Private Functions
    
    private func searchParameters(city: CityGeocode?) -> URL? {
        guard let safeCity = city else { return nil }
        
        var searchString = safeCity.name
        
        if let state = safeCity.state {
            searchString.append(",\(state)")
        }

        if let country = safeCity.country {
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
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        do {
            let decoded = try decoder.decode(CityWeather.self, from: data)
            print(decoded)
        } catch {
            print(error.localizedDescription)
        }
    }
}
