//
//  SettingsCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var router: Router

    init(router: Router) {
        self.router = router
    }

    func start() {
        let destinationVC = MainSettingsViewController.instantiateWith(storyboardName: .settings)
        destinationVC.setDataBaseManager(DataBaseManager.instance)
        destinationVC.setUnitMeasurement(UnitMeasurementManager.instance)

        destinationVC.onSelectDetailWeatherSettings = {
            self.selectDetailWeather()
        }
        
        router.push(viewController: destinationVC, animated: true)
    }

    private func selectDetailWeather() {
        let destinationVC = DetailWeatherSettingsViewController.instantiateWith(storyboardName: .settings)
        destinationVC.setDataBaseManager(DataBaseManager.instance)
        destinationVC.setDetailWeatherManager(DetailWeatherManager.instance)

        router.push(viewController: destinationVC, animated: true)
    }
}
