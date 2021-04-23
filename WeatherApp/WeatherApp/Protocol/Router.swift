//
//  Router.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

protocol Router {
    var navigationController: UINavigationController { get set }

    func push(viewController: UIViewController, animated: Bool)
    func pop()
}

extension Router {
    func push(viewController: UIViewController, animated: Bool) {}
    func pop() {}
}

class ConcreteRouter: Router {
    var navigationController: UINavigationController

    init(navController: UINavigationController) {
        self.navigationController = navController
    }

    func push(viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(viewController: UIViewController) {
        navigationController.popViewController(animated: true)
    }
}
