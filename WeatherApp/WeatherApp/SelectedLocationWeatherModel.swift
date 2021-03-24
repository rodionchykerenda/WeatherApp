//
//  SelectedLocationWeatherModel.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

struct SelectedLocationWeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let longtitude: Double
    let lattitude: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
