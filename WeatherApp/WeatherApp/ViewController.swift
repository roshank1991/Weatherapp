//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rosh on 31/01/25.
//

import UIKit
import CoreLocation
import Network


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var btnSearchCity: UIButton!
    var activityView: UIActivityIndicatorView?
    
    @IBOutlet weak var myLocLabel: UILabel!
    
    @IBOutlet weak var myLocbtn: UIButton!
    
    
    let locationManager = CLLocationManager()
    
    let apiKey = "57e85b6fcf808b3c51dc9336a1f9e277"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
            btnSearchCity.backgroundColor = .red
            btnSearchCity.layer.cornerRadius = 5
            btnSearchCity.layer.borderWidth = 1
            btnSearchCity.layer.borderColor = UIColor.clear.cgColor
            btnSearchCity.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
            myLocbtn.backgroundColor = .red
            myLocbtn.layer.cornerRadius = 5
            myLocbtn.layer.borderWidth = 1
            myLocbtn.layer.borderColor = UIColor.clear.cgColor
            myLocbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
          
            CityLabel.font = UIFont.boldSystemFont(ofSize: 26.0)
            CityLabel.textColor = UIColor.white
            CityLabel.isHidden = true
            
            tempLabel.font = UIFont.boldSystemFont(ofSize: 26.0)
            tempLabel.textColor = UIColor.white
            tempLabel.isHidden = true
           
            descLabel.font = UIFont.boldSystemFont(ofSize: 26.0)
            descLabel.textColor = UIColor.white
            descLabel.isHidden = true
           
             myLocLabel.textColor = UIColor.white
            myLocLabel.isHidden = true
            
            
    
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        showActivityIndicator()
        self.view.isUserInteractionEnabled = false
        
        
    }
    
    func showNoInternetAlert() { // Alert for no internet connection
        let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        hideActivityIndicator()
        self.view.isUserInteractionEnabled = true;
    }
    
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Reachability.shared.isConnectedToNetwork() {
            print("Internet is available")
            // Fetch data or perform any network operation here
            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {                           locationManager.startUpdatingLocation()
            }
            
        } else {
            print("No internet connection")
            // Show alert or handle no internet case here
            showNoInternetAlert()
            return
        }
        
}
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle changes in location authorization
        print("Location authorization status: \(status.rawValue)")  // Print the current status
        
        if status == .authorizedWhenInUse {
            // Location authorized, start updating location
            locationManager.startUpdatingLocation()
        } else if status == .notDetermined {
            // Handle when location permission dialog is not yet responded to
            print("Location permission not yet determined. Awaiting user decision.")
            locationManager.requestWhenInUseAuthorization()

        }
        else if status == .denied {
            // Handle when location permission dialog is not yet responded to

            print("Location permission not yet determined. Awaiting user decision.")
            hideActivityIndicator()
            self.view.isUserInteractionEnabled = true
            
        }
        
        else {
            
           print("error")
        }
    }
    
    
    

    func showLocationDisabledAlert() {
        hideActivityIndicator()
        self.view.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Location Disabled",
                                      message: "Enable location services in Settings or search for a city manually.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
    func fetchWeather(lat: Double, lon: Double) {
        
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching weather: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                
                DispatchQueue.main.async { [self] in
                    self.myLocLabel.text = "MY LOCATION"
                    self.CityLabel.text = "\(weatherData.name)"
                    self.tempLabel.text = "\(Int(weatherData.main.temp))°C"
                    self.descLabel.text = weatherData.weather.first?.description.capitalized ?? "No Description"
                    self.myLocLabel.isHidden = false
                    self.CityLabel.isHidden = false
                    self.tempLabel.isHidden = false
                    self.descLabel.isHidden = false
                    self.hideActivityIndicator()
                    self.view.isUserInteractionEnabled = true
                    
                    
                }
            } catch {
                
                print("Error decoding: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    
                    self.hideActivityIndicator()
                    self.view.isUserInteractionEnabled = true
                    
                    
                    self.showLocationServicesError(message: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        hideActivityIndicator()
        self.view.isUserInteractionEnabled = true
        
        
       // self.showLocationServicesError(message: error.localizedDescription)
        
    }
    
    // Open Search Screen
    @IBAction func searchCityTapped(_ sender: UIButton) {
        
        
        if Reachability.shared.isConnectedToNetwork() {
            print("Internet is available")
            // Fetch data or perform any network operation here
           
            let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchVC.delegate = self
            
            present(searchVC, animated: true)
            
            
        } else {
            print("No internet connection")
            // Show alert or handle no internet case here
            showNoInternetAlert()
            return
        }
        
        
        
    }
    
    @IBAction func myLocTapped(_ sender: Any) {
        
        if Reachability.shared.isConnectedToNetwork() {
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()  // Start location updates when button is pressed
            } else {
                showLocationDisabledAlert()  // Show alert if location services are disabled
            }
            
            
        } else {
            print("No internet connection")
            // Show alert or handle no internet case here
            showNoInternetAlert()
            return
        }
        
    }
    
}





// Update UI when a city is selected
extension ViewController: SearchCityDelegate {
    func didSelectCity(_ city: String) {
        CityLabel.text = "\(city)"
        fetchWeather(city: city)
        showActivityIndicator()
        self.view.isUserInteractionEnabled = false
        self.CityLabel.isHidden = true
        self.tempLabel.isHidden = true
        self.descLabel.isHidden = true
        self.myLocLabel.isHidden = true
    }
    
    
    
    func fetchWeather(city: String) {
        
        // shows city data which is selected from the search controller.
        let cityName = getCityNameBeforeCommaAndRemoveSpaces(city: city)
        let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        
        
        let urlString = "\(baseURL)?q=\(encodedCity)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching weather: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.view.isUserInteractionEnabled = true
                    self.showLocationServicesError(message: error.localizedDescription)
                    
                    self.CityLabel.text = ""
                    self.tempLabel.text = ""
                    self.descLabel.text = ""
                    
                    self.CityLabel.isHidden = false
                    self.tempLabel.isHidden = false
                    self.descLabel.isHidden = false
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                
                DispatchQueue.main.async {
                    self.CityLabel.text = "\(weatherData.name)"
                    self.tempLabel.text = "\(Int(weatherData.main.temp))°C"
                    self.descLabel.text = weatherData.weather.first?.description.capitalized ?? "No Description"
                    
                    self.hideActivityIndicator()
                    self.view.isUserInteractionEnabled = true
                    self.CityLabel.isHidden = false
                    self.tempLabel.isHidden = false
                    self.descLabel.isHidden = false
                    self.myLocLabel.isHidden = true
                    
                    
                    
                }
            } catch {
                print("Error decoding: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    
                    self.hideActivityIndicator()
                    self.view.isUserInteractionEnabled = true
                    
                    
                    self.CityLabel.text = ""
                    self.tempLabel.text = ""
                    self.descLabel.text = ""
                    
                    self.CityLabel.isHidden = false
                    self.tempLabel.isHidden = false
                    self.descLabel.isHidden = false
                    
                    self.showLocationServicesError(message: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getCityNameBeforeCommaAndRemoveSpaces(city: String) -> String {
        // Check if the city contains a comma
        if city.contains(",") {
            // Split the string at the comma and return the first part with spaces removed
            let cityComponents = city.split(separator: ",")
            return cityComponents.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        } else {
            // If no comma, return the city name with spaces removed
            return city.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    
    
    func showLocationServicesError(message:String) {
        
        let alertController = UIAlertController(title:"Location Error", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
}




