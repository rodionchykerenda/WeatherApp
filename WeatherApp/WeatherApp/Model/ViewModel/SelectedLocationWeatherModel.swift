//
//  SelectedLocationWeatherModel.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

protocol WeatherModel {
    var cityName: String { get set }
    var temperature: String? { get set }
    var longtitude: Double { get set }
    var lattitude: Double { get set }
}

struct SelectedLocationWeatherModel: WeatherModel {
    var cityName: String
    var temperature: String?
    var longtitude: Double
    var lattitude: Double
}
