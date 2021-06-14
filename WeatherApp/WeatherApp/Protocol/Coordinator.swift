//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var router: Router { get set }
    var managerFactory: ManagerFactoryProtocol { get set }

    func start()
}
