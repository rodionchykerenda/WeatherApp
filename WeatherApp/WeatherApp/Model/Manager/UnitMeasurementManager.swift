//
//  UnitMeasurementManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import Foundation

protocol UnitMeasurementManagerProtocol {
    var hours: TimeFormat { get set }
    var metrics: TemperatureMeasurement { get set }
    var distance: DistanceMeasurement { get set }
}

class UnitMeasurementManager: UnitMeasurementManagerProtocol {
    static let instance = UnitMeasurementManager()

    var hours: TimeFormat = .twentyFour
    var metrics: TemperatureMeasurement = .celcius
    var distance: DistanceMeasurement = .metres
}
