//
//  ViewController.swift
//  WeatherApp
//
//  Created by Edgar Barocio on 5/28/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var cityWeatherViewModel = CityWeatherViewModel()
    
    @IBOutlet var searchBar: UIView!
    @IBOutlet var weatherImage: UIView!
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

