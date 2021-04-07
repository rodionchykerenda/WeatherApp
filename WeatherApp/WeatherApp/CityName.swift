//
//  CityName.swift
//  WeatherApp
//
//  Created by Rodion Chikerenda on 26.03.2021.
//

import Foundation

struct CityName: Codable {
    let localNames: LocalNames

    private enum CodingKeys: String, CodingKey {
        case localNames = "local_names"
    }
}

struct LocalNames: Codable {
    let english: String
    let russian: String

    private enum CodingKeys: String, CodingKey {
        case english = "en"
        case russian = "ru"
    }
}
