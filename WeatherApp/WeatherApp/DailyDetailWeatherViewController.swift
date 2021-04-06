//
//  DailyDetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 02.04.2021.
//

import UIKit

class DailyDetailWeatherViewController: UIViewController, Spinner {
    // MARK: - Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!

    // MARK: - Public Properties
    var loaderView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        Storage.instance.attach(self)

        guard !Storage.instance.isLoading else {

            showSpinner()
            return
        }

        updateUI()
    }

    deinit {
        print("Daily Deinit")
    }
}

// MARK: - Observer Methods
extension DailyDetailWeatherViewController: StorageObserver {
    func update(storage: Storage) {
//        guard let globalWeather = storage.globalWeather else {
//
//            return
//        }

        DispatchQueue.main.async {
            self.updateUI()

            self.removeSpinner()
        }
    }
}

// MARK: - Helpers
private extension DailyDetailWeatherViewController {
    func updateUI() {
        guard let globalWeather = Storage.instance.globalWeather else { return }

        self.temperatureLabel.text = String(globalWeather.current.feelsLike)
    }
}
