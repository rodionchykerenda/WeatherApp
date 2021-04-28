//
//  WeatherViewModelConverter.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 27.04.2021.
//

import Foundation

protocol DetailWeatherDataManager: class {
    func getDetailWeatherViewModalArray(from networkModel: GlobalWeatherData) -> [DetailWeatherViewModel]
    func getHoursWeatherViewModelArray(from networkModelArray: [HourlyWeatherData]) -> [HoursWeatherViewModel]
    func getCurrentWeatherModel(from networkModel: CurrentWeatherData, with name: String) -> MainCurrentWeatherViewModel
    func getDailyWeatherViewModelArray(from networkModelArray: [DailyWeatherData]) -> [DailyDetailWeatherModel]
}
