//
//  SelectedLocationCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import Foundation

class SelectedLocationCoordinator: Coordinator {
    var managerFactory: ManagerFactoryProtocol
    
    var router: Router

    init(router: Router, factory: ManagerFactoryProtocol) {
        self.router = router
        self.managerFactory = factory
    }

    func start() {
        let destinationVC = SelectedLocationsViewController.instantiateWith(storyboardName: .main)
        
        destinationVC.setDataManipulationManager(managerFactory.getDataManipulationManager())
        destinationVC.setUnitMeasurementHelper(UnitMeasurementHelper())

        destinationVC.onSelectDetailWeather = { [weak self] in
            guard let selfCoordinator = self else { return }

            let detailsCoordinator = DetailsCoordinator(router: selfCoordinator.router, factory: selfCoordinator.managerFactory)
            detailsCoordinator.start()
        }

        destinationVC.onSelectAddButton = { [weak self] in
            let destinationVC = MapViewController.instantiateWith(storyboardName: .main)

            destinationVC.onSelectAddButton = { [weak self] (latitude, longitude) in
                self?.updateInterfaces(longitude: longitude, latitude: latitude)
            }

            self?.router.push(viewController: destinationVC, animated: true)
        }

        destinationVC.onSelectSettingsButton = { [weak self] in
            guard let selfCoordinator = self else { return }

            let settingsCoordinator = SettingsCoordinator(router: selfCoordinator.router, factory: selfCoordinator.managerFactory)
            settingsCoordinator.start()
        }

        router.push(viewController: destinationVC, animated: true)

        let dataBaseManager = DataBaseManager()
        
        if !dataBaseManager.getLocations().isEmpty {
            destinationVC.onSelectDetailWeather?()
        }
    }

    private func updateInterfaces(longitude: Double, latitude: Double) {
        router.navigationController.viewControllers.forEach {
            ($0 as? UpdatableWithLocation)?.didSelectOnMap(location: (longitude: longitude,
                                                                      latitude: latitude))
        }
    }
}
