//
//  DetailsCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

class DetailsCoordinator: Coordinator {
    var managerFactory: ManagerFactoryProtocol
    var router: Router

    init(router: Router, factory: ManagerFactoryProtocol) {
        self.router = router
        self.managerFactory = factory
    }

    func start() {
        let detailWeatherVC = DetailWeatherViewController.instantiateWith(storyboardName: .detail)
        detailWeatherVC.setDataManager(managerFactory.getDetailWeatherDataManager())
        detailWeatherVC.setStorage(managerFactory.getStorageManager())
        detailWeatherVC.setCollectionViewHandlers(hours: managerFactory.getHoursCollectionViewHandler(),
                                                  detail: managerFactory.getDetailCollectionViewHandler())
        
        let dailyDetailWeatherVC = DailyDetailWeatherViewController.instantiateWith(storyboardName: .detail)
        dailyDetailWeatherVC.setDataManager(managerFactory.getDetailWeatherDataManager())
        dailyDetailWeatherVC.setStorage(managerFactory.getStorageManager())
        
        let dataBaseManager = DataBaseManager()
        detailWeatherVC.selectedLocation = dataBaseManager.getLocations().last

        let tabBarViewController = UITabBarController()
        detailWeatherVC.title = NSLocalizedString("weather", comment: "")
        dailyDetailWeatherVC.title = NSLocalizedString("daily", comment: "")
        tabBarViewController.setViewControllers([detailWeatherVC, dailyDetailWeatherVC], animated: false)

        router.push(viewController: tabBarViewController, animated: true)
    }
}
