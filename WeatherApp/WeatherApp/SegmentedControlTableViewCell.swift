//
//  SegmentedControlTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import UIKit

protocol SegmentedControlTableViewCellDelegate: class {
    func segmentedControlTableViewCell(_ sender: SegmentedControlTableViewCell, selectedOption: Int)
}

class SegmentedControlTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    // MARK: - Public Properties
    static let identifier = "SegmentedControlTableViewCell"
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

            if hoursSelectedEnum == .twentyFour {
                segmentedControl.selectedSegmentIndex = 1
            }

        case .metrics:
            guard let tempSelectedEnum = selectedOption as? TemperatureMeasurement else {
                return
            }

            if tempSelectedEnum == .farenheit {
                segmentedControl.selectedSegmentIndex = 1
            }

        case .distance:
            guard let distanceSelectedEnum = selectedOption as? DistanceMeasurement else {
                return
            }

            if distanceSelectedEnum == .miles {
                segmentedControl.selectedSegmentIndex = 1
            }

        default:
            return
        }
    }

    // MARK: - Actions
    @IBAction private func segmentedControlChanged(_ sender: UISegmentedControl) {
        delegate?.segmentedControlTableViewCell(self,
                                                selectedOption: sender.selectedSegmentIndex)
    }
}
