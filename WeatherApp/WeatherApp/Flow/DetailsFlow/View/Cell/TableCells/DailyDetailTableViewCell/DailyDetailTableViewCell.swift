//
//  DailyDetailTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class DailyDetailTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var dayNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!

    func update(with dailyWeatherModel: DailyDetailWeatherModel) {
        dayNameLabel.text = dailyWeatherModel.dayName
        temperatureLabel.text = dailyWeatherModel.temperature
        conditionImage.image = UIImage(systemName: dailyWeatherModel.conditionName)
    }
}
