//
//  ViewController.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        cityWeatherViewModel.delegate = self
        cityWeatherViewModel.locationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        self.searchBar.text = defaults.string(forKey: "StoredSearch")
    }
    // MARK: - Internal Methods
    @objc func dismissKeyboard() {
      searchBar.resignFirstResponder()
    }
}

extension ViewController: UISearchBarDelegate {
    
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
    
    private func search(entry: String) {
        let defaults = UserDefaults.standard
        defaults.set(entry, forKey: "StoredSearch")
        
        cityWeatherViewModel.performSearch(entry: entry)
    }
}

extension ViewController: WeatherResultsProtocolDelegate {
    func displayCurrentWeather(weather: CityWeather) {
        self.descriptionLabel.text = weather.description
        self.currentTempLabel.text = String(format: "Temp: %.2f", weather.temp)
        self.minimumTempLabel.text = String(format: "Min Temp: %.2f", weather.tempMin)
        self.maximumTempLabel.text = String(format: "Min Temp: %.2f", weather.tempMax)
        self.feelsLikeLabel.text = String(format: "Feels like: %.2f", weather.feelsLike)
        
        cityWeatherViewModel.getImagefromURL(url: weather.iconURL)
    }
    
    func displayImageData(data: Data) {
        self.weatherImageView.image =  UIImage(data: data)
    }
}

extension ViewController: CurrentLocationProtocol {
    func updateLocation(location: CityGeocode) {
        self.searchBar.text = location.name
        self.search(entry: location.name)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    //MARK: - Location calls
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



