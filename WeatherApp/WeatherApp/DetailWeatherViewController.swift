//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 29.03.2021.
//

import UIKit

class DetailWeatherViewController: UIViewController, Spinner {
    // MARK: - Outlets
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!

    // MARK: - Public Properties
    var selectedLocation: SelectedLocation?
    var loaderView: UIView?

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        showSpinner()

        guard let longitude = selectedLocation?.longitude,
              let latitude = selectedLocation?.latitude,
              let cityName = selectedLocation?.name else {
            return
        }

        Storage.instance.attach(self)

        self.cityNameLabel.text = cityName

        Storage.instance.getWeatherForLocationBy(longitude: Double(truncating: longitude),
                                        latitude: Double(truncating: latitude))
    }

    deinit {
        print("Detail Deinit")
    }
}

// MARK: - Observer Methods
extension DetailWeatherViewController: StorageObserver {
    func update(storage: Storage) {
        DispatchQueue.main.async {
            self.updateUI()
            self.removeSpinner()

        }
    }
}

// MARK: - Helpers
private extension DetailWeatherViewController {
    func updateUI() {
        guard let globalWeather = Storage.instance.globalWeather else { return }

        temperatureLabel.text = String(globalWeather.current.feelsLike)
    }
}
