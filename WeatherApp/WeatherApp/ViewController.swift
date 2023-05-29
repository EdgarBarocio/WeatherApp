//
//  ViewController.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private var locationManager: CLLocationManager?
    
    private var cityWeatherViewModel = CityWeatherViewModel()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minimumTempLabel: UILabel!
    @IBOutlet weak var maximumTempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    

    lazy var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
    
    /**
     Override function that initializes location services
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        cityWeatherViewModel.delegate = self
        cityWeatherViewModel.locationDelegate = self
    }

    /**
     Override funtion to retrieve a previous search automatically
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        self.searchBar.text = defaults.string(forKey: "StoredSearch")
    }
// MARK: - Internal Methods
    /**
     Function to hide the keyboard when performing a search
     */
    @objc func dismissKeyboard() {
      searchBar.resignFirstResponder()
    }
}

// MARK: - Extension for Search Bar functions
extension ViewController: UISearchBarDelegate {
    
    /**
     Function that reads the Search Bar and calls an internal function to perform search
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        search(entry: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      view.removeGestureRecognizer(tapRecognizer)
    }
    
    /**
     Private function to signal to the View Model to perform the search for weather
     
     -  Parameters:
        - entry: String from the Search bar or User defautls, this is the search parameter
     */
    private func search(entry: String) {
        let defaults = UserDefaults.standard
        defaults.set(entry, forKey: "StoredSearch")
        
        cityWeatherViewModel.performSearch(entry: entry)
    }
}

// MARK: - Extension to implement WeatherResultProtocolDelegate
extension ViewController: WeatherResultsProtocolDelegate {
    /**
     Implementation of the WeatherResultsProtocolDelegate, this takes the data from the View Model and updates the UI with the results.
     Also asks the view model to fetch the image for the main weather icon.
     
     - Parameters:
        - weather:CityWeather struct holding the parameters to display after the Weather Search
     */
    func displayCurrentWeather(weather: CityWeather) {
        self.descriptionLabel.text = weather.description
        self.currentTempLabel.text = String(format: "Temp: %.2f", weather.temp)
        self.minimumTempLabel.text = String(format: "Min Temp: %.2f", weather.tempMin)
        self.maximumTempLabel.text = String(format: "Min Temp: %.2f", weather.tempMax)
        self.feelsLikeLabel.text = String(format: "Feels like: %.2f", weather.feelsLike)
        
        cityWeatherViewModel.getImagefromURL(url: weather.iconURL)
    }
    
    /**
     Implementation of the WeatherResultsProtocolDelegate, this takes the Data of Weather icon representing the currrent weather of the search.
     
     - Parameters:
        - data:Raw image data, this can be from the service or cache
     */
    func displayImageData(data: Data) {
        self.weatherImageView.image =  UIImage(data: data)
    }
}

// MARK: - Extension for CurrentLocationProtocol
extension ViewController: CurrentLocationProtocol {
    /**
     Implementation of the CurrentLocationProtocol, takes the last saved location (if authorized), pre-fills search bar with the search term and e
     automatically executes the weather search.
     
     - Parameters:
        - location: CityGeocode location struct holding the previous search, uses only .name for simplicity
     */
    func updateLocation(location: CityGeocode) {
        self.searchBar.text = location.name
        self.search(entry: location.name)
    }
}
// MARK: - Extension for LocationServices
extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        cityWeatherViewModel.getCityFromLocation(location: location)
    }
    
    private func checkAuthorization() {
        
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            /// app is authorized
            locationManager?.startUpdatingLocation()
        default:
            break
        }
    }
}



