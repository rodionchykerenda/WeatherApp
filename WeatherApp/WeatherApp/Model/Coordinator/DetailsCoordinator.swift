//
//  DetailsCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

class DetailsCoordinator: Coordinator {
    var router: Router

    init(router: Router) {
        self.router = router
    }

    func start() {
        let detailWeatherVC = DetailWeatherViewController.instantiateWith(storyboardName: .detail)
        let dailyDetailWeatherVC = DailyDetailWeatherViewController.instantiateWith(storyboardName: .detail)

        detailWeatherVC.selectedLocation = DataBaseManager.instance.getLocations().last

        let tabBarViewController = UITabBarController()
        detailWeatherVC.title = NSLocalizedString("weather", comment: "")
        dailyDetailWeatherVC.title = NSLocalizedString("daily", comment: "")
        tabBarViewController.setViewControllers([detailWeatherVC, dailyDetailWeatherVC], animated: false)

        router.push(viewController: tabBarViewController, animated: true)
    }
    
    private func selectDetailWeather() {
        let destinationVC = DetailWeatherSettingsViewController.instantiateWith(storyboardName: .settings)

        router.push(viewController: destinationVC, animated: true)
    }
}
