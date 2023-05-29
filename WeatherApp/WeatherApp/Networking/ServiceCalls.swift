//
//  ServiceCalls.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

/// Services Calls class
///  given more time, the completion closures would have error handling, not only prints fomr the base call
class ServiceCalls {
    
    /// Local image caching in NSData format, stores NSData in cache
    private let imageCache = NSCache<NSString, NSData>()
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    
    typealias WeatherResult = (Data) -> Void
    typealias ImageDownload = (Data) -> Void
    typealias LocationResult = (Data) -> Void
    
    /**
     Service call to get Weather information
     
     - Parameters:
        - url: Service URL
        - completion: Closure to pass response back to the View Model
     */
    func getWeatherResults(url: URL, completion: @escaping WeatherResult) {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            
        }
        
        dataTask?.resume()
    }
    
    /**
     Service call that downloads and stores image data to cache.
        Made de decision to implement the Cache here to avoid making service calls for assets previously called
     
     - Parameters:
        - url: Weather image URL in string format
        - completion: Closure that passes the image data from service or cache to the View Model
     */
    func downloadImage(url: String, completion:@escaping ImageDownload) {
        dataTask?.cancel()
        
        if let cachedImageData = imageCache.object(forKey: url as NSString) {
            completion(cachedImageData as Data)
            return
        }
        
        guard let imageURL = URL(string: url) else {
            return
            
        }
        
        dataTask = defaultSession.dataTask(with: imageURL) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                //store the data in cache
                self?.imageCache.setObject(data as NSData, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
        
        dataTask?.resume()
    }
    
    /**
     Service call to get the reverse geocode from a location
     
     - Parameters:
        - url: URL for reverse geocoding
        - completion: Closure to pass result to View Model
     */
    func getCity(url: URL, completion: @escaping LocationResult) {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            
        }
        
        dataTask?.resume()
    }
}
