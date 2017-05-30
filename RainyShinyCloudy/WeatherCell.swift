//
//  WeatherCell.swift
//  RainyShinyCloudy
//
//  Created by Árthur Ken Aramaki Mota on 29/05/17.
//  Copyright © 2017 Árthur Ken Aramaki Mota. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    func configureCell(forecast: Forecast) {
        
        lowTempLabel.text = "\(forecast.lowTemp)ºF"
        highTempLabel.text = "\(forecast.highTemp)ºF"
        weatherTypeLabel.text = forecast.weatherType
        weatherIcon.image = UIImage(named: forecast.weatherType)
        dayLabel.text = forecast.date
        
        
        
    }
    
    
}
