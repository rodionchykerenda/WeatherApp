//
//  SelectedLocationTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit

class SelectedLocationTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    //MARK: - Helpers
    func update(selectedLocation: SelectedLocationWeatherModel) {
        cityNameLabel.text = selectedLocation.cityName
        temperatureLabel.text = selectedLocation.temperatureString + "°С"
    }
}
