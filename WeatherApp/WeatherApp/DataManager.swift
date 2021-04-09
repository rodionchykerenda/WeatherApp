//
//  DataManager.swift
//  WeatherApp
//
//  Created by Rodion Chikerenda on 28.03.2021.
//

import UIKit

class DataManager {
    static let instance = DataManager()

    private let dateFormater = DateFormatter()

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
        let date = Date(timeIntervalSince1970: Double(networkModel.date))
        dateFormater.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = dateFormater.string(from: date).capitalized

        dateFormater.dateFormat = "HH:mm"
        let sunriseDate = Date(timeIntervalSince1970: Double(networkModel.sunrise))
        let sunsetDate = Date(timeIntervalSince1970: Double(networkModel.sunset))
        let sunrise = dateFormater.string(from: sunriseDate)
        let sunset = dateFormater.string(from: sunsetDate)
        let temperature = String(Int(networkModel.temperature)) + "°С"
        let conditionName = getConditionName(by: networkModel.weather[0].id)
        let description = networkModel.weather[0].description.components(separatedBy: " ").map {
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
        let minTemp = String(Int(networkModel.daily[0].temperature.minTemp)) + "°С"
        let maxTemp = String(Int(networkModel.daily[0].temperature.maxTemp)) + "°С"
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
        let date = Date(timeIntervalSince1970: Double(networkModel.date))
        dateFormater.dateFormat = "EEEE"
        let dayString = dateFormater.string(from: date).capitalized

        let temperature = String(Int(networkModel.temperature.daily)) + "°С"

        let condtitionName = getConditionName(by: networkModel.weather[0].id)

        return DailyDetailWeatherModel(dayName: dayString, temperature: temperature, conditionName: condtitionName)
    }

    private func getHoursViewModel(from networkModel: HourlyWeatherData) -> HoursWeatherViewModel {
        let temperature = String(Int(networkModel.temperature)) + "°С"

        let time = Date(timeIntervalSince1970: Double(networkModel.date))
        dateFormater.dateFormat = "HH:mm"
        let timeString = dateFormater.string(from: time).capitalized

        let conditionName = getConditionName(by: networkModel.weather[0].id)

        return HoursWeatherViewModel(time: timeString, temperature: temperature, conditionName: conditionName)
    }
}
