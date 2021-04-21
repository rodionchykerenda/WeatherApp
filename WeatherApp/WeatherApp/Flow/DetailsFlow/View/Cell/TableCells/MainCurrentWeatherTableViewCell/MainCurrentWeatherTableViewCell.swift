//
//  MainCurrentWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 08.04.2021.
//

import UIKit

class MainCurrentWeatherTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var conditionWeatherImage: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var sunsetLabel: UILabel!
    @IBOutlet private weak var sunriseLabel: UILabel!
    @IBOutlet private weak var sunriseImage: UIImageView!
    @IBOutlet private weak var sunsetImage: UIImageView!

    // MARK: - Setters
    func update(with model: MainCurrentWeatherViewModel?) {
        cityNameLabel.text = model?.cityName
        weatherDescriptionLabel.text = model?.description
        dateLabel.text = model?.date

        guard let imageString = model?.conditionName else { return }

        conditionWeatherImage.image = UIImage(systemName: imageString)
        temperatureLabel.text = model?.temperature
        sunsetLabel.text = model?.sunset
        sunriseLabel.text = model?.sunrise

        sunriseImage.image = UIImage(systemName: "sunrise.fill")
        sunsetImage.image = UIImage(systemName: "sunset")
    }
}
