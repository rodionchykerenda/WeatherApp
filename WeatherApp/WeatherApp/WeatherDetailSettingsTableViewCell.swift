//
//  WeatherDetailSettingsTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 14.04.2021.
//

import UIKit

class WeatherDetailSettingsTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var cellNameLabel: UILabel!

    // MARK: - Setters
    func update(name: String) {
        cellNameLabel.text = name
    }
}
