//
//  MainSettingsViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import UIKit

class MainSettingsViewController: UIViewController, StoryboardLoadable {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    private var saveButton = UIBarButtonItem()

    // MARK: - Private Properties
    private var dataSource: [SettingsRowsViewModel] = [.hours,
                                                       .metrics,
                                                       .distance,
                                                       .details]
    private let unitMeasurementManager = UnitMeasurementManager.instance
    private let dataBaseManager = DataBaseManager.instance

    // MARK: - Output
    var onSelectDetailWeatherSettings: (() -> Void)?

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpTableView()
    }

    // MARK: - Actions
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        dataBaseManager.deleteAllUnits()
        dataBaseManager.addUnit(hours: unitMeasurementManager.hours.rawValue,
                                distance: unitMeasurementManager.distance.rawValue,
                                metrics: unitMeasurementManager.metrics.rawValue)
        saveButton.isEnabled = false
    }
}

// MARK: - Helpers
private extension MainSettingsViewController {
    func setUpUI() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
    }

    func setUpTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(cellType: SegmentedControlTableViewCell.self)
        contentTableView.register(cellType: WeatherDetailSettingsTableViewCell.self)
    }

    func setUpSegmentedControlCell(name: String,
                                   segmentedControlNames: (first: String, second: String),
                                   selectedOption: MeasurementEnum,
                                   categoryName: SettingsRowsViewModel,
                                   for indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(for: indexPath, cellType: SegmentedControlTableViewCell.self)

        cell.delegate = self

        cell.update(rowName: name,
                    valueNames: (first: segmentedControlNames.first, second: segmentedControlNames.second),
                    selectedOption: selectedOption,
                    categoryName: categoryName)

        return cell
    }
}

// MARK: - TableView Delegate & DataSource Methods
extension MainSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.row] {
        case .hours:
            return setUpSegmentedControlCell(name: NSLocalizedString("hours", comment: ""),
                                             segmentedControlNames: (first: String.twelve, second: String.twentyFour),
                                             selectedOption: unitMeasurementManager.hours,
                                             categoryName: dataSource[indexPath.row],
                                             for: indexPath)
        case .metrics:
            return setUpSegmentedControlCell(name: NSLocalizedString("metrics", comment: ""),
                                             segmentedControlNames: (first: String.celcius, second: String.farenheit),
                                             selectedOption: unitMeasurementManager.metrics,
                                             categoryName: dataSource[indexPath.row],
                                             for: indexPath)
        case .distance:
            return setUpSegmentedControlCell(name: NSLocalizedString("distance", comment: ""),
                                             segmentedControlNames: (first: NSLocalizedString("metres", comment: ""),
                                                                     second: NSLocalizedString("miles", comment: "")),
                                             selectedOption: unitMeasurementManager.distance,
                                             categoryName: dataSource[indexPath.row],
                                             for: indexPath)

        case .details:
            let cell = contentTableView.dequeueReusableCell(for: indexPath, cellType: WeatherDetailSettingsTableViewCell.self)

            cell.update(name: NSLocalizedString("weather_details", comment: ""))

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource[indexPath.row] == .details else {
            return
        }

        onSelectDetailWeatherSettings?()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - SegmentedControlCell Delegate Methods
extension MainSettingsViewController: SegmentedControlTableViewCellDelegate {
    func segmentedControlTableViewCell(_ sender: SegmentedControlTableViewCell, didSelectOption selectedOption: Int) {
        guard let indexPath = contentTableView.indexPath(for: sender) else {
            return
        }

        saveButton.isEnabled = true

        let isSelectedOptionZero = selectedOption == 0

        switch dataSource[indexPath.row] {
        case .hours:
            unitMeasurementManager.hours = isSelectedOptionZero ? .twelve : .twentyFour

        case .distance:
            unitMeasurementManager.distance = isSelectedOptionZero ? .metres : .miles

        case .metrics:
            unitMeasurementManager.metrics = isSelectedOptionZero ? .celcius : .farenheit

        default:
            return
        }
    }
}
