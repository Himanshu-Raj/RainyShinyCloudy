//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Árthur Ken Aramaki Mota on 27/05/17.
//  Copyright © 2017 Árthur Ken Aramaki Mota. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var currentWeather : CurrentWeather!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    
        currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails {
            
            self.updateMainUI()
            
        }
        
        
    }

    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        
        return cell
        
    }

    // Setting the height of the cell to 80
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Methods
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

