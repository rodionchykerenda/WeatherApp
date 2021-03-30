//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coordinates
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct Coordinates: Codable {
    let longitude: Double
    let latitude: Double

    private enum CodingKeys : String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
