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
                                            longtitude: Double(longitude), lattitude: Double(latitude))
    }

    func getDataSourceModelArray(from coreDataModelArray: [SelectedCity]) -> [SelectedLocationWeatherModel] {
        var resultArray = [SelectedLocationWeatherModel]()

        for item in coreDataModelArray {
            resultArray.append(getDataSourceModel(from: item))
        }

        return resultArray
    }

    func isContainedCurrentLocation(in dataSource: [WeatherModel]) -> Bool {
        for item in dataSource
        where item as? CurrentLocationWeatherModel != nil {
            return true

        }

        return false
    }
}
