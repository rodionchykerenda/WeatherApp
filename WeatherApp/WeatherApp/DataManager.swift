//
//  DataManager.swift
//  WeatherApp
//
//  Created by Rodion Chikerenda on 28.03.2021.
//

import Foundation

class DataManager {
    static let instance = DataManager()

    func getDataSourceModel(from coreDataModel: SelectedCity) -> SelectedLocationWeatherModel {
        guard let name = coreDataModel.name,
              let longitude = coreDataModel.longitude,
              let latitude = coreDataModel.latitude else {
            fatalError()
        }
        return SelectedLocationWeatherModel(cityName: name,
                                            temperature: nil,
                                            longtitude: Double(truncating: longitude),
                                            lattitude: Double(truncating: latitude))
    }

    func getDataSourceModelArray(from coreDataModelArray: [SelectedCity]) -> [SelectedLocationWeatherModel] {
        return coreDataModelArray.compactMap { getDataSourceModel(from: $0) }
    }

    func isContainedCurrentLocation(in dataSource: [WeatherModel]) -> Bool {
        return !dataSource.filter { $0 as? CurrentLocationWeatherModel != nil }.isEmpty
    }
}
