//
//  MeasurementEnums.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 13.04.2021.
//

import Foundation

protocol MeasurementEnum {}

enum DistanceMeasurement: String, MeasurementEnum {
    case metres = "metres"
    case miles = "miles"
}

enum TemperatureMeasurement: String, MeasurementEnum {
    case celcius = "°С"
    case farenheit = "°F"
}

enum TimeFormat: String, MeasurementEnum {
    case twelve = "12"
    case twentyFour = "24"
}
