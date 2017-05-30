//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Árthur Ken Aramaki Mota on 27/05/17.
//  Copyright © 2017 Árthur Ken Aramaki Mota. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather : CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //locationAuthStatus()
    }

    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            
            return cell
        } else {
            
            return WeatherCell()
            
        }
        
    }

    // Setting the height of the cell to 80
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // MARK: - Methods
    
    ///////
    
    // TODO: FIX THE TABLEVIEW INFINITE LOOP
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation //an array of CLLocations
        
        Location.sharedInstance.latitude = userLocation.coordinate.latitude
        Location.sharedInstance.longitude = userLocation.coordinate.longitude
        
        currentWeather = CurrentWeather()
        
        currentWeather.downloadWeatherDetails {
            
            self.downloadForecastData {
                self.tableView.reloadData()
                self.updateMainUI()

            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //If requestLocation() fails then default to San Francisco Coordinates
        Location.sharedInstance.latitude = 37.785834
        Location.sharedInstance.longitude = -122.406417
        
        //Update UI with default data
        currentWeather = CurrentWeather()
        
        currentWeather.downloadWeatherDetails {
            
            self.downloadForecastData {
                self.tableView.reloadData()
                self.updateMainUI()
            }
            
        }
    }
    
    
    //////
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            
            //currentLocation = locationManager.location
            //Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            //Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            //print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            locationManager.requestLocation() //implements didUpdateLocations delegate
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
        
    }
    
    
    
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)ºF"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        // Downloading forecast weather data for TableView
        
        //let forecastURL = URL(string: forecast_url)!
        Alamofire.request(forecast_url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                        
                    }
                    
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                    
                }

            }
        
            completed()
            
        }
        
    }
    
    
}

