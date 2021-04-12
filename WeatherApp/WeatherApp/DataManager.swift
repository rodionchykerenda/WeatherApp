//
//  DataManager.swift
//  WeatherApp
//
//  Created by Rodion Chikerenda on 28.03.2021.
//

import UIKit

class DataManager {
    static let instance = DataManager()

    private let dateHelper = Helper()

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

    func getCurrentWeatherModel(from networkModel: CurrentWeatherData, with name: String) -> MainCurrentWeatherViewModel {
        let dateString = dateHelper.getFullDate(with: Double(networkModel.date))
        let sunrise = dateHelper.getOnlyTimeDate(with: networkModel.sunrise)
        let sunset = dateHelper.getOnlyTimeDate(with: networkModel.sunset)
        let temperature = String(Int(networkModel.temperature)) + "°С"

        guard let weather = networkModel.weather.first else {
            fatalError()
        }

        let conditionName = getConditionName(by: weather.id)
        let description = weather.description.components(separatedBy: " ").map {
            $0.capitalized
        }.joined(separator: " ")

        return MainCurrentWeatherViewModel(cityName: name,
                                           description: description,
                                           conditionName: conditionName,
                                           temperature: temperature,
                                           sunset: sunset,
                                           sunrise: sunrise,
                                           date: dateString)
    }

    func getHoursWeatherViewModelArray(from networkModelArray: [HourlyWeatherData]) -> [HoursWeatherViewModel] {
        return networkModelArray.map {
            getHoursViewModel(from: $0)
        }
    }

    func getDetailWeatherViewModalArray(from networkModel: GlobalWeatherData) -> [DetailWeatherViewModel] {
        let humidity = String(networkModel.current.humidity) + "%"
        let windSpeed = String(Int(networkModel.current.windSpeed)) + "m/s"

        guard let firstDayTemperature = networkModel.daily.first else {
            fatalError()
        }

        let minTemp = String(Int(firstDayTemperature.temperature.minTemp)) + "°С"
        let maxTemp = String(Int(firstDayTemperature.temperature.maxTemp)) + "°С"
        let feelsLike = String(Int(networkModel.current.feelsLike)) + "°С"
        let pressure = String(Int(networkModel.current.pressure)) + "hPa"

        return [DetailWeatherViewModel(name: .humidity, value: humidity),
                DetailWeatherViewModel(name: .windSpeed, value: windSpeed),
                DetailWeatherViewModel(name: .minTemp, value: minTemp),
                DetailWeatherViewModel(name: .maxTemp, value: maxTemp),
                DetailWeatherViewModel(name: .feelsLike, value: feelsLike),
                DetailWeatherViewModel(name: .pressure, value: pressure)]
    }

    func getImage(from detailWeatherName: DetailWeatherName) -> UIImage? {
        switch detailWeatherName {
        case .humidity:
            return UIImage(named: "humidity")
        case .pressure:
            return UIImage(named: "pressure")
        case .windSpeed:
            return UIImage(named: "windspeed")
        case .minTemp:
            return UIImage(systemName: "arrow.down.circle")
        case .maxTemp:
            return UIImage(systemName: "arrow.up.circle")
        case .feelsLike:
            return UIImage(systemName: "heart")
        }
    }

    func getLocalizedName(from detailWeatherName: DetailWeatherName) -> String {
        switch detailWeatherName {
        case .humidity:
            return NSLocalizedString("humidity", comment: "")
        case .pressure:
            return NSLocalizedString("pressure", comment: "")
        case .windSpeed:
            return NSLocalizedString("wind_speed", comment: "")
        case .minTemp:
            return NSLocalizedString("min_temp", comment: "")
        case .maxTemp:
            return NSLocalizedString("max_temp", comment: "")
        case .feelsLike:
            return NSLocalizedString("feels_like", comment: "")
        }
    }

    func getDailyWeatherViewModelArray(from networkModelArray: [DailyWeatherData]) -> [DailyDetailWeatherModel] {
        return networkModelArray.map {
            getDailyViewModel(from: $0)
        }
    }

    // MARK: - Helpers
    private func getConditionName(by id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }

    private func getDailyViewModel(from networkModel: DailyWeatherData) -> DailyDetailWeatherModel {
        let dayString = dateHelper.getOnlyDayDate(with: Double(networkModel.date))

        let temperature = String(Int(networkModel.temperature.daily)) + "°С"

        guard let weather = networkModel.weather.first else {
            fatalError()
        }

        let condtitionName = getConditionName(by: weather.id)

        return DailyDetailWeatherModel(dayName: dayString, temperature: temperature, conditionName: condtitionName)
    }

    private func getHoursViewModel(from networkModel: HourlyWeatherData) -> HoursWeatherViewModel {
        let temperature = String(Int(networkModel.temperature)) + "°С"

        let timeString = dateHelper.getOnlyTimeDate(with: Double(networkModel.date))

        guard let weather = networkModel.weather.first else {
            fatalError()
        }

        let conditionName = getConditionName(by: weather.id)

        return HoursWeatherViewModel(time: timeString, temperature: temperature, conditionName: conditionName)
    }
}
