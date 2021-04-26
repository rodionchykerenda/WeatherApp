//
//  UpdatableWithLocation.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 23.04.2021.
//

import Foundation

protocol UpdatableWithLocation: class {
    func didSelectOnMap(location: (longitude: Double?, latitude: Double?))
}
