//
//  DailyDetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 02.04.2021.
//

import UIKit

class DailyDetailWeatherViewController: UIViewController, LoadableView {
    // MARK: - Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!

    // MARK: - Private Properties
    let storage = StorageManager.instance

    // MARK: - Public Properties
    var loaderView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
}

// MARK: - Observer Methods
extension DailyDetailWeatherViewController: StorageObserver {
    func didGetUpdated(storage: StorageManager) {
        DispatchQueue.main.async {
            self.updateUI()

            self.removeSpinner()
        }
    }
}

// MARK: - Helpers
private extension DailyDetailWeatherViewController {
    func updateUI() {
        guard let globalWeather = storage.globalWeather else { return }

        temperatureLabel.text = String(globalWeather.current.feelsLike)
    }

    func loadData() {
        storage.attach(self)

        guard !storage.isLoading else {
            showSpinner()
            return
        }

        updateUI()
    }
}
