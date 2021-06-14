//
//  SwitchTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 14.04.2021.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchTableViewCell(_ sender: SwitchTableViewCell, didSelectOption selectedOption: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var detailWeatherNameLabel: UILabel!
    @IBOutlet private weak var isSelectedSwitch: UISwitch!

    // MARK: - Public Properties
    weak var delegate: SwitchTableViewCellDelegate?

    // MARK: - Setters
    func update(with settingsModel: DetailWeatherSettingsViewModel) {
        let dataManager = DataManager()
        detailWeatherNameLabel.text = dataManager.getLocalizedName(from: settingsModel.name)
        isSelectedSwitch.setOn(settingsModel.isSelected, animated: false)
    }

    // MARK: - Actions
    @IBAction private func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchTableViewCell(self, didSelectOption: sender.isOn)
    }
}
