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
        guard let name = coreDataModel.name, let lon = coreDataModel.longitude, let lat = coreDataModel.latitude else {
            fatalError()
        }
        return SelectedLocationWeatherModel(cityName: name, temperature: nil, longtitude: Double(lon), lattitude: Double(lat))
    }
    
    func getDataSourceModelArray(from coreDataModelArray: [SelectedCity]) -> [SelectedLocationWeatherModel] {
        var resultArray = [SelectedLocationWeatherModel]()
        
        
        for item in coreDataModelArray {
            resultArray.append(getDataSourceModel(from: item))
        }
        
        return resultArray
    }
}
