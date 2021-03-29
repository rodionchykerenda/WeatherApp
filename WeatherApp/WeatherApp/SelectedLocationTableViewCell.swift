//
//  SelectedLocationTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit

class SelectedLocationTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    private var spinner: UIActivityIndicatorView?
    
    //MARK: - Helpers
    func update(selectedLocation: SelectedLocationWeatherModel) {
        cityNameLabel.text = selectedLocation.cityName
        if let temp = selectedLocation.temperature {
            temperatureLabel.text = String(format: "%.0f", temp) + "°С"
            removeActivityIndicator()
        } else {
            addActivityIndicator()
        }
        styleUI()
    }
    
    func styleUI() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func addActivityIndicator() {
        temperatureLabel.isHidden = true
        spinner?.isHidden = false
        spinner = UIActivityIndicatorView(frame: CGRect(x: self.frame.size.width - 70, y: self.frame.size.height - 70, width: 50, height: 50))
        spinner?.startAnimating()
        contentView.addSubview(spinner!)
    }
    
    func removeActivityIndicator() {
        temperatureLabel.isHidden = false
        spinner?.stopAnimating()
        spinner?.isHidden = true
    }
}
