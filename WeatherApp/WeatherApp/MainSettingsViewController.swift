//
//  MainSettingsViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import UIKit

class MainSettingsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    private var saveButton = UIBarButtonItem()

    // MARK: - Private Properties
    private var dataSource: [SettingsRowsViewModel] = [.hours, .metrics, .distance]
    private let unitMeasurementManager = UnitMeasurementManager.instance
    private let dataBaseManager = DataBaseManager.instance

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
        contentTableView.register(UINib(nibName: String(describing: SegmentedControlTableViewCell.self), bundle: nil),
                                  forCellReuseIdentifier: SegmentedControlTableViewCell.identifier)
    }

    func setUpSegmentedControlCell(name: String,
                                   segmentedControlNames: (first: String, second: String),
                                   selectedOption: MeasurementEnum,
                                   categoryName: SettingsRowsViewModel,
                                   for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentTableView.dequeueReusableCell(withIdentifier: SegmentedControlTableViewCell.identifier,
                                                       for: indexPath) as? SegmentedControlTableViewCell else {
            fatalError()
        }

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
            return setUpSegmentedControlCell(name: "Hours",
                                             segmentedControlNames: (first: "12", second: "24"),
                                             selectedOption: unitMeasurementManager.hours,
                                             categoryName: dataSource[indexPath.row],
                                             for: indexPath)
        case .metrics:
            return setUpSegmentedControlCell(name: "Metrics",
                                             segmentedControlNames: (first: "°C", second: "°F"),
                                             selectedOption: unitMeasurementManager.metrics,
                                             categoryName: dataSource[indexPath.row],
                                             for: indexPath)
        case .distance:
            return setUpSegmentedControlCell(name: "Distance",
                                             segmentedControlNames: (first: NSLocalizedString("metres", comment: ""),
                                                                     second: NSLocalizedString("miles", comment: "")),
                                             selectedOption: unitMeasurementManager.distance,
                                             categoryName: dataSource[indexPath.row],
                                             for: indexPath)
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - SegmentedControlCell Delegate Methods
extension MainSettingsViewController: SegmentedControlTableViewCellDelegate {
    func segmentedControlTableViewCell(_ sender: SegmentedControlTableViewCell, selectedOption: Int) {
        guard let indexPath = contentTableView.indexPath(for: sender) else {
            return
        }

        saveButton.isEnabled = true

        switch dataSource[indexPath.row] {
        case .hours:
            unitMeasurementManager.hours = selectedOption == 0 ? .twelve : .twentyFour

        case .distance:
            unitMeasurementManager.distance = selectedOption == 0 ? .metres : .miles

        case .metrics:
            unitMeasurementManager.metrics = selectedOption == 0 ? .celcius : .farenheit

        default:
            return
        }
    }
}
