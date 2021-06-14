//
//  ManagerFactory.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 30.04.2021.
//

import Foundation

protocol ManagerFactoryProtocol {
    func getDataManipulationManager() -> DataManipulationManager
    
    func getHoursCollectionViewHandler() -> CollectionViewHandler
    func getDetailCollectionViewHandler() -> CollectionViewHandler
    func getDetailWeatherDataManager() -> DetailWeatherDataManager
    func getStorageManager() -> StorageManagerProtocol
    
    func getUnitMeasurementManager() -> UnitMeasurementManagerProtocol
    func getSettingsDataBaseManager() -> SettingsDataBaseManager
    func getDetailWeatherManager() -> DetailWeatherManagerProtocol
}

class ManagerFactory: ManagerFactoryProtocol {
    func getDataManipulationManager() -> DataManipulationManager {
        return MainDataManipulationManager(dataManager: DataManager(), dataBaseManager: DataBaseManager())
    }
    
    func getHoursCollectionViewHandler() -> CollectionViewHandler {
        return HoursWeatherHandler()
    }
    
    func getDetailCollectionViewHandler() -> CollectionViewHandler {
        return DetailWeatherHandler()
    }
    
    func getDetailWeatherDataManager() -> DetailWeatherDataManager {
        return DataManager()
    }
    
    func getStorageManager() -> StorageManagerProtocol {
        return StorageManager.instance
    }
    
    func getUnitMeasurementManager() -> UnitMeasurementManagerProtocol {
        return UnitMeasurementManager.instance
    }
    
    func getSettingsDataBaseManager() -> SettingsDataBaseManager {
        return DataBaseManager()
    }
    
    func getDetailWeatherManager() -> DetailWeatherManagerProtocol {
        return DetailWeatherManager.instance
    }
}
