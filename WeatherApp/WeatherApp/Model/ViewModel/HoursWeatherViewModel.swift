//
//  HoursWeatherViewModel.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import Foundation

protocol CollectionViewModel {
}

struct HoursWeatherViewModel: CollectionViewModel {
    var time: String
    var temperature: String
    var conditionName: String
}
