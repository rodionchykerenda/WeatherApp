//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 23.04.2021.
//

import Foundation

class AppCoordinator: Coordinator {
    var router: Router
    var mainCoordinator: Coordinator?

    init(router: Router) {
        self.router = router
    }

    func start() {
        mainCoordinator = SelectedLocationCoordinator(router: router)
        mainCoordinator?.start()
    }
}
