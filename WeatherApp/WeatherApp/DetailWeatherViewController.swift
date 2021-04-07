//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 29.03.2021.
//

import UIKit

class DetailWeatherViewController: UIViewController, LoadableView {
    // MARK: - Outlets
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!

    // MARK: - Private Properties
    private let srotage = StorageManager.instance

    // MARK: - Public Properties
    var selectedLocation: SelectedLocation?
    var loaderView: UIView?

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
}

// MARK: - Observer Methods
extension DetailWeatherViewController: StorageObserver {
    func didGetUpdated(globalWeatherData: GlobalWeatherData?) {
        DispatchQueue.main.async {
            self.updateUI()
            self.removeSpinner()
        }
    }
}

// MARK: - Helpers
private extension DetailWeatherViewController {
    func updateUI() {
        guard let globalWeather = srotage.getGlobalWeatherData() else { return }

        temperatureLabel.text = String(globalWeather.current.temperature)
    }

    func loadData() {
        showSpinner()

        guard let longitude = selectedLocation?.longitude,
              let latitude = selectedLocation?.latitude,
              let cityName = selectedLocation?.name else {
            return
        }

        srotage.attach(self)

        self.cityNameLabel.text = cityName

        srotage.getWeatherForLocationBy(longitude: Double(truncating: longitude),
                                        latitude: Double(truncating: latitude))
    }
}
