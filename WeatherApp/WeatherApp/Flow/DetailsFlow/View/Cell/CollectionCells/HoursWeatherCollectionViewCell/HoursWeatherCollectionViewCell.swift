//
//  HoursWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class HoursWeatherCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var timeOutlet: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!

    func update(with hoursWeatherModel: HoursWeatherViewModel) {
        timeOutlet.text = hoursWeatherModel.time
        temperatureLabel.text = hoursWeatherModel.temperature
        conditionImage.image = UIImage(systemName: hoursWeatherModel.conditionName)
    }
}
