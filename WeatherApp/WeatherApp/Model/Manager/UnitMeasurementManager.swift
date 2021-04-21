//
//  UnitMeasurementManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import Foundation

class UnitMeasurementManager {
    static let instance = UnitMeasurementManager()

    var hours: TimeFormat = .twentyFour
    var metrics: TemperatureMeasurement = .celcius
    var distance: DistanceMeasurement = .metres
}
