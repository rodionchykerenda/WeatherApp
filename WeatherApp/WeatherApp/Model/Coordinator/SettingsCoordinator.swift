//
//  SettingsCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let destinationVC = MainSettingsViewController.instantiateWith(storyboardName: .settings)
        destinationVC.setCoorinator(self)
        navigationController.pushViewController(destinationVC, animated: true)
    }

    func selectDetailWeather() {
        let destinationVC = DetailWeatherSettingsViewController.instantiateWith(storyboardName: .settings)
        navigationController.pushViewController(destinationVC, animated: true)
    }
}
