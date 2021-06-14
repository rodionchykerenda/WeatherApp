//
//  SettingsDataBaseManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 27.04.2021.
//

import Foundation

protocol SettingsDataBaseManager: AnyObject {
    func addUnit(hours: String, distance: String, metrics: String)
    func deleteAllUnits()
    func addAttributes(_ attributes: [DetailWeatherSettingsViewModel])
    func deleteAllAttributes()
}
