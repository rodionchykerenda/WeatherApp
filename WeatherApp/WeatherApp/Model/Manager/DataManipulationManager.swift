//
//  DataManipulationManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 27.04.2021.
//

import Foundation

protocol DataManipulationManager: class {
    var dataManager: SelectedLocationDataManager { get set }
    var dataBaseManager: SelectedLocationDataBaseManager { get set }

    init(dataManager: SelectedLocationDataManager,
         dataBaseManager: SelectedLocationDataBaseManager)
    
    func addCityToDataBase(latitude: Double, longitude: Double, name: String)
    func addLocationToDataBase(latitude: Double, longitude: Double, name: String)
    func getDataSourceModelArray() -> [SelectedLocationWeatherModel]
    func getCities() -> [SelectedCity]
    func deleteAllLocations()
    func delete(city: SelectedCity)
}

class MainDataManipulationManager: DataManipulationManager {
    var dataBaseManager: SelectedLocationDataBaseManager
    var dataManager: SelectedLocationDataManager

    required init(dataManager: SelectedLocationDataManager,
                  dataBaseManager: SelectedLocationDataBaseManager) {
        self.dataManager = dataManager
        self.dataBaseManager = dataBaseManager
    }

    func addCityToDataBase(latitude: Double, longitude: Double, name: String) {
        dataBaseManager.addCity(latitude: latitude, longitude: longitude, name: name)
    }

    func addLocationToDataBase(latitude: Double, longitude: Double, name: String) {
        dataBaseManager.addLocation(latitude: latitude, longitude: longitude, name: name)
    }

    func getDataSourceModelArray() -> [SelectedLocationWeatherModel] {
        return dataManager.getDataSourceModelArray(from: dataBaseManager.getCities())
    }

    func getCities() -> [SelectedCity] {
        return dataBaseManager.getCities()
    }

    func deleteAllLocations() {
        dataBaseManager.deleteAllLocations()
    }

    func delete(city: SelectedCity) {
        dataBaseManager.delete(city: city)
    }

    deinit {
        print("DEINITED")
    }
}
