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

    // MARK: - Public functions
    /**
        Function that ejecutes the weather search
     
     - Parameters:
        - entry: String from the search bar
     */
    func performSearch(entry: String) {
        let searchArray = entry.components(separatedBy: [","]).filter({!$0.isEmpty})
        let city = createCityGeocode(searchArray)
        let searchURL = searchParameters(city: city)
        
        if let safeURL = searchURL {
            serviceCalls.getWeatherResults(url: safeURL) {[weak self] result in
                self?.parseResponse(data: result)
            }
        }
    }
    
    /**
        Function that downloads the Main weather icon
     
     - Parameters:
        - url: Image url in string format
     */
    func getImagefromURL(url: String) {
        serviceCalls.downloadImage(url: url) { [weak self] result in
            self?.delegate?.displayImageData(data: result)
        }
    }
    
    /**
     Function that performs the reverse geocoding service call to get a location from a CLLocation
     
     - Parameters:
        - location: Saved CLLocation
     */
    func getCityFromLocation(location: CLLocation?) {
        
        guard let safeLocation = location else { return }
        
        let geocodeString = String(format: NetworkConstants.reverseGeocodingURL, safeLocation.coordinate.latitude, safeLocation.coordinate.longitude)
        let geocodeURL = URL(string: geocodeString)
        
        if let safeURL = geocodeURL {
            serviceCalls.getCity(url: safeURL) { [weak self] result in
                self?.parseGeolocation(data: result)
            }
        }
    }
    
    //MARK: - Private Functions
    /**
    Private function that builds the URL for the weather service call from a CityGeocode object
     
     - Parameters:
        - city: CityGeocode struct storing Name, state and country.
     
     - Returns:Optional URL for the Weather search call
     */
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
    
    /**
     Private function that buidls a CityGeocode struct from an array of entries
     
     - Parameters:
        - parameters: Array of string representing the search from the search bar. Example: ["New York", "NY", "USA"]
     
     - Returns: CityGeocode struct
     */
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
    
    /**
     Prifave function to parse the response of the Weather service call, passing the result to the view through displayCurrentWeather()
     
     - Parameters:
        -  data: Service call response in Data format
     */
    private func parseResponse(data: Data) {
        var responseDictionary: [String: Any]?
        // Used JSONSerialization instead of JSONDecoder because I could not get it to decode the nested JSONs
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
    
    /**
     Prifave function to parse the Geolocaition service data, then calls the locationDelegate protocol to automatically perform the Search and fill the city info on the search bar
     
     - Parameters:
        -  data: Service call response in Data format
     */
    private func parseGeolocation(data: Data) {
        var responseDictionary: [String: Any]?
        
        do {
            /// Service returns JSON inside an array. Given more time, I would have found a cleaner decoding, instead of converting to string,
            /// dropping the brackets manually instead of using a range and converting to data to use Serialization
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
