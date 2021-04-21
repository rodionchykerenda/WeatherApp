//
//  GlobalWeatherData.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 02.04.2021.
//

import Foundation

struct GlobalWeatherData: Codable {
    let current: CurrentWeatherData
    let hourly: [HourlyWeatherData]
    let daily: [DailyWeatherData]
}
