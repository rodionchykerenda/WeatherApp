//
//  DetailWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class DetailWeatherCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var detailWeatherImage: UIImageView!
    @IBOutlet private weak var detailWeatherNameLabel: UILabel!
    @IBOutlet private weak var detailWeatherValueLabel: UILabel!

    func update(with detailWeatherViewModel: DetailWeatherViewModel) {
        detailWeatherNameLabel.text = DataManager.instance.getLocalizedName(from: detailWeatherViewModel.name)
        detailWeatherValueLabel.text = detailWeatherViewModel.value

        detailWeatherImage.image = DataManager.instance.getImage(from: detailWeatherViewModel.name)
    }
}
