//
//  CurrentLocationWeatherModel.swift
//  WeatherApp
//
//  Created by Rodion Chikerenda on 01.04.2021.
//

import Foundation

struct CurrentLocationWeatherModel: WeatherModel {
    var cityName: String = NSLocalizedString("current_location", comment: "")
    var temperature: Double?
    var longtitude: Double
    var lattitude: Double
}
