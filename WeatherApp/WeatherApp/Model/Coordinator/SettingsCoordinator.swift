//
//  SettingsCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var managerFactory: ManagerFactoryProtocol
    var router: Router

    init(router: Router, factory: ManagerFactoryProtocol) {
        self.router = router
        self.managerFactory = factory
    }

    func start() {
        let destinationVC = MainSettingsViewController.instantiateWith(storyboardName: .settings)
        destinationVC.setDataBaseManager(managerFactory.getSettingsDataBaseManager())
        destinationVC.setUnitMeasurement(managerFactory.getUnitMeasurementManager())

        destinationVC.onSelectDetailWeatherSettings = {
            self.selectDetailWeather()
        }
        
        router.push(viewController: destinationVC, animated: true)
    }

    private func selectDetailWeather() {
        let destinationVC = DetailWeatherSettingsViewController.instantiateWith(storyboardName: .settings)
        destinationVC.setDataBaseManager(managerFactory.getSettingsDataBaseManager())
        destinationVC.setDetailWeatherManager(managerFactory.getDetailWeatherManager())

        router.push(viewController: destinationVC, animated: true)
    }
}
