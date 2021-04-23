//
//  SelectedLocationCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import Foundation

class SelectedLocationCoordinator: Coordinator {
    var router: Router

    init(router: Router) {
        self.router = router
    }

    func start() {
        let destinationVC = SelectedLocationsViewController.instantiateWith(storyboardName: .main)
        destinationVC.onSelectDetailWeather = { [weak self] in
            guard let selfCoordinator = self else { return }

            let detailsCoordinator = DetailsCoordinator(router: selfCoordinator.router)
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

            let settingsCoordinator = SettingsCoordinator(router: selfCoordinator.router)
            settingsCoordinator.start()
        }

        router.push(viewController: destinationVC, animated: true)

        if !DataBaseManager.instance.getLocations().isEmpty {
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
