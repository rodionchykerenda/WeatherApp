//
//  DetailWeatherData.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 02.04.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let date: Int
    let sunrise: Double
    let sunset: Double
    let temperature: Double
    let humidity: Double
    let windSpeed: Double
    let feelsLike: Double
    let pressure: Double
    let weather: [Weather]

    private enum CodingKeys : String, CodingKey {
        case date = "dt"
        case windSpeed = "wind_speed"
        case feelsLike = "feels_like"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case temperature = "temp"
        case humidity = "humidity"
        case pressure = "pressure"
        case weather = "weather"
    }
}

struct HourlyWeatherData: Codable {
    let date: Int
    let temperature: Double
    let weather: [Weather]

    private enum CodingKeys : String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case weather = "weather"
    }
}

struct Temperature: Codable {
    let daily: Double

    private enum CodingKeys : String, CodingKey {
        case daily = "day"
    }
}

struct DailyWeatherData: Codable {
    let date: Int
    let temperature: Temperature
    let weather: [Weather]

    private enum CodingKeys : String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case weather = "weather"
    }
}
