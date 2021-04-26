//
//  DetailWeatherSettingsViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 14.04.2021.
//

import UIKit

class DetailWeatherSettingsViewController: UIViewController, StoryboardLoadable {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    private var saveButton = UIBarButtonItem()
    
    // MARK: - Private Properties
    private var dataSource = [DetailWeatherSettingsViewModel]()
    private let detailWeatherManager = DetailWeatherManager.instance
    private let dataBaseManager = DataBaseManager.instance

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpDataSource()
        setUpTableView()
    }

    // MARK: - Actions
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        detailWeatherManager.detailWeatherToPresent = dataSource.map {
            return DetailWeatherSelection(detailWeather: $0.name, isSelected: $0.isSelected)
        }

        dataBaseManager.deleteAllAttributes()
        dataBaseManager.addAttributes(dataSource)

        saveButton.isEnabled = false
    }
}

// MARK: - Helpers
private extension DetailWeatherSettingsViewController {
    func setUpDataSource() {
        dataSource = detailWeatherManager.detailWeatherToPresent.map {
            return DetailWeatherSettingsViewModel(name: $0.detailWeather, isSelected: $0.isSelected)
        }
    }

    func setUpTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.setEditing(true, animated: true)
        contentTableView.register(cellType: SwitchTableViewCell.self)
    }

    func setUpUI() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
    }
}

// MARK: - TableView Delegate & DataSource Methods
extension DetailWeatherSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SwitchTableViewCell.self)

        cell.update(with: dataSource[indexPath.row])
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource.insert(dataSource.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        saveButton.isEnabled = true
    }
}

// MARK: - SwitchTableViewCell Delegate Methods
extension DetailWeatherSettingsViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ sender: SwitchTableViewCell, didSelectOption selectedOption: Bool) {
        guard let indexPath = contentTableView.indexPath(for: sender) else {
            return
        }

        saveButton.isEnabled = true
        dataSource[indexPath.row].isSelected = selectedOption
    }
}
