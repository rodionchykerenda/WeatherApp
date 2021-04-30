//
//  SegmentedControlTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import UIKit

protocol SegmentedControlTableViewCellDelegate: AnyObject {
    func segmentedControlTableViewCell(_ sender: SegmentedControlTableViewCell, didSelectOption selectedOption: Int)
}

class SegmentedControlTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    // MARK: - Public Properties
    weak var delegate: SegmentedControlTableViewCellDelegate?

    // MARK: - Setters
    func update(rowName: String,
                valueNames: (first: String, second: String),
                selectedOption: MeasurementEnum,
                categoryName: SettingsRowsViewModel) {
        labelName.text = rowName
        segmentedControl.setTitle(valueNames.first, forSegmentAt: 0)
        segmentedControl.setTitle(valueNames.second, forSegmentAt: 1)

        switch categoryName {
        case .hours:
            guard let hoursSelectedEnum = selectedOption as? TimeFormat else {
                return
            }

            switch hoursSelectedEnum {
            case .twentyFour:
                segmentedControl.selectedSegmentIndex = 1

            case .twelve:
                segmentedControl.selectedSegmentIndex = 0
            }

        case .metrics:
            guard let tempSelectedEnum = selectedOption as? TemperatureMeasurement else {
                return
            }

            switch tempSelectedEnum {
            case .farenheit:
                segmentedControl.selectedSegmentIndex = 1

            case .celcius:
                segmentedControl.selectedSegmentIndex = 0
            }

        case .distance:
            guard let distanceSelectedEnum = selectedOption as? DistanceMeasurement else {
                return
            }

            switch distanceSelectedEnum {
            case .miles:
                segmentedControl.selectedSegmentIndex = 1

            case .metres:
                segmentedControl.selectedSegmentIndex = 0
            }

        default:
            return
        }
    }

    // MARK: - Actions
    @IBAction private func segmentedControlChanged(_ sender: UISegmentedControl) {
        delegate?.segmentedControlTableViewCell(self,
                                                didSelectOption: sender.selectedSegmentIndex)
    }
}
