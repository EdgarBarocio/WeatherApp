//
//  ServiceCalls.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import Foundation

class ServiceCalls {
    
    private let imageCache = NSCache<NSString, NSData>()
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    
    
    typealias WeatherResult = (Data, String) -> Void
    typealias ImageDownload = (Data) -> Void
    
    func getWeatherResults(url: URL, completion: @escaping WeatherResult) {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "Data task error: " + error.localizedDescription + "\n"
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    completion(data, self?.errorMessage ?? "")
                }
            }
            
        }
        
        dataTask?.resume()
    }
    
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
                self?.errorMessage += "Data task error: " + error.localizedDescription + "\n"
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                self?.imageCache.setObject(data as NSData, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
        
        dataTask?.resume()
    }
}
