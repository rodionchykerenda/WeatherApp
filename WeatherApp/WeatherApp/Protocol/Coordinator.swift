//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

protocol Coordinator: class {
    var router: Router { get set }

    func start()
}
