//
//  SelectedLocationWeatherModel.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

// model remove
protocol WeatherModel {
    var cityName: String { get set }
    var temperature: Double? { get set }
    var longtitude: Double { get set }
    var lattitude: Double { get set }
}

struct SelectedLocationWeatherModel: WeatherModel {
    var cityName: String
    var temperature: Double?
    var longtitude: Double
    var lattitude: Double
}
