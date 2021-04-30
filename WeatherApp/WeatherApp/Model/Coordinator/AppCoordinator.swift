//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 23.04.2021.
//

import Foundation

class AppCoordinator: Coordinator {
    var managerFactory: ManagerFactoryProtocol
    var router: Router
    var mainCoordinator: Coordinator?

    init(router: Router, factory: ManagerFactoryProtocol) {
        self.router = router
        self.managerFactory = factory
    }

    func start() {
        mainCoordinator = SelectedLocationCoordinator(router: router, factory: managerFactory)
        mainCoordinator?.start()
    }
}
