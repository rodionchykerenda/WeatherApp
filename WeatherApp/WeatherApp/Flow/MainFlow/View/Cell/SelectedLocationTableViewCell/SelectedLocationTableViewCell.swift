//
//  SelectedLocationTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit

class SelectedLocationTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    private var spinner: UIActivityIndicatorView?

    // MARK: - Setters
    func update(selectedLocation: WeatherModel) {
        cityNameLabel.text = selectedLocation.cityName

        if let temperature = selectedLocation.temperature {
            temperatureLabel.text = temperature
            removeActivityIndicator()
        } else {
            addActivityIndicator()
        }

        styleUI()
    }
}

// MARK: - Private Helpers
private extension SelectedLocationTableViewCell {
    func styleUI() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func addActivityIndicator() {
        spinner = UIActivityIndicatorView()

        guard let spinner = spinner else {
            fatalError()
        }

        contentView.addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        spinner.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        spinner.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: cityNameLabel.safeAreaLayoutGuide.rightAnchor).isActive = true

        temperatureLabel.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
    }

    func removeActivityIndicator() {
        temperatureLabel.isHidden = false
        spinner?.stopAnimating()
        spinner?.isHidden = true
    }
}
