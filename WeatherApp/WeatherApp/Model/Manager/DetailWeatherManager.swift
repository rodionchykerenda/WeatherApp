//
//  DetailWeatherHelper.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 14.04.2021.
//

import Foundation

protocol DetailWeatherManagerProtocol {
    var detailWeatherToPresent: [DetailWeatherSelection] { get set }
}

class DetailWeatherManager: DetailWeatherManagerProtocol {
    static let instance = DetailWeatherManager()

    var detailWeatherToPresent: [DetailWeatherSelection] = [DetailWeatherSelection(detailWeather: .humidity, isSelected: true),
                                                            DetailWeatherSelection(detailWeather: .windSpeed, isSelected: true),
                                                            DetailWeatherSelection(detailWeather: .minTemp, isSelected: true),
                                                            DetailWeatherSelection(detailWeather: .maxTemp, isSelected: true),
                                                            DetailWeatherSelection(detailWeather: .feelsLike, isSelected: true),
                                                            DetailWeatherSelection(detailWeather: .pressure, isSelected: true)]
}

struct DetailWeatherSelection {
    var detailWeather: DetailWeatherName
    var isSelected: Bool
}
