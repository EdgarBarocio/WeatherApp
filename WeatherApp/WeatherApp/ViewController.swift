//
//  ViewController.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import UIKit

class ViewController: UIViewController {
    
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
        cityWeatherViewModel.delegate = self
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
        
        cityWeatherViewModel.performSearch(entry: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      view.removeGestureRecognizer(tapRecognizer)
    }
}

extension ViewController: WeatherResultsProtocolDelegate {
    func displayCurrentWeather(weather: CityWeather) {
        self.descriptionLabel.text = weather.description
        self.currentTempLabel.text = String(format: "Temp: %f", weather.temp)
        self.minimumTempLabel.text = String(format: "Min Temp: %f", weather.tempMin)
        self.maximumTempLabel.text = String(format: "Min Temp: %f", weather.tempMax)
        self.feelsLikeLabel.text = String(format: "Feels like: %f", weather.feelsLike)
        
        cityWeatherViewModel.getImagefromURL(url: weather.iconURL)
    }
    
    func displayImageData(data: Data) {
        self.weatherImageView.image =  UIImage(data: data)
    }
}
