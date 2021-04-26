//
//  Storyboarded.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 22.04.2021.
//

import UIKit

protocol StoryboardLoadable {
    static func instantiateWith(storyboardName: StoryboardName) -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    static func instantiateWith(storyboardName: StoryboardName) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)

        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: id) as? Self else {
            fatalError("Couldnt instantiate VC with id: \(id)")
        }

        return destinationVC
    }
}
