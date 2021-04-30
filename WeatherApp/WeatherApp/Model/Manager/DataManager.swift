//
//  DataManager.swift
//  WeatherApp
//
//  Created by Rodion Chikerenda on 28.03.2021.
//

import UIKit

protocol SelectedLocationDataManager {
    func getDataSourceModelArray(from coreDataModelArray: [SelectedCity]) -> [SelectedLocationWeatherModel]
}

class DataManager {
    private let measurementHelper = UnitMeasurementHelper()

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

    func getDetailWeatherEnum(by string: String) -> DetailWeatherName {
        if let result = DetailWeatherName.allCases.filter({ $0.rawValue == string }).first {
            return result
        }

        fatalError("Incorrect value in DataBase")
    }

    func getDistanceMeasurement(from string: String) -> DistanceMeasurement {
        if string == String.metres {
            return .metres
        }

        return .miles
    }

    func getTimeFormat(from string: String) -> TimeFormat {
        if string == String.twelve {
            return .twelve
        }

        return .twentyFour
    }

    func getTemperatureMeasurement(from string: String) -> TemperatureMeasurement {
        if string == "°С" {
            return .celcius
        }

        return .farenheit
    }
}

// MARK: - SelectedLocationDataManager Methods
extension DataManager: SelectedLocationDataManager {
    func getDataSourceModelArray(from coreDataModelArray: [SelectedCity]) -> [SelectedLocationWeatherModel] {
        return coreDataModelArray.compactMap { getDataSourceModel(from: $0) }
    }
}

// MARK: - DetailWeatherDataManager Methods
extension DataManager: DetailWeatherDataManager {
    func getDailyWeatherViewModelArray(from networkModelArray: [DailyWeatherData]) -> [DailyDetailWeatherModel] {
        return networkModelArray.map {
            getDailyViewModel(from: $0)
        }
    }

    func getHoursWeatherViewModelArray(from networkModelArray: [HourlyWeatherData]) -> [HoursWeatherViewModel] {
        return networkModelArray.map {
            getHoursViewModel(from: $0)
        }
    }

    func getDetailWeatherViewModalArray(from networkModel: GlobalWeatherData) -> [DetailWeatherViewModel] {
        var resultArray = [DetailWeatherViewModel]()

        guard let firstDayTemperature = networkModel.daily.first else {
            fatalError("Server didnt give daily weather")
        }
        // swiftlint:disable line_length
        DetailWeatherManager.instance.detailWeatherToPresent.forEach {
            if $0.isSelected {
                switch $0.detailWeather {
                case .humidity:
                    resultArray.append(DetailWeatherViewModel(name: $0.detailWeather,
                                                              value: String(networkModel.current.humidity) + "%"))

                case .windSpeed:
                    resultArray.append(DetailWeatherViewModel(name: $0.detailWeather,
                                                              value: measurementHelper.getCorrectDistanceMeasurement(from: networkModel.current.windSpeed)))

                case .pressure:
                    resultArray.append(DetailWeatherViewModel(name: $0.detailWeather,
                                                              value: String(Int(networkModel.current.pressure)) + "hPa"))

                case .feelsLike:
                    resultArray.append(DetailWeatherViewModel(name: $0.detailWeather,
                                                              value: measurementHelper.getCorrectTemperature(from: networkModel.current.feelsLike)))

                case .minTemp:
                    resultArray.append(DetailWeatherViewModel(name: $0.detailWeather,
                                                              value: measurementHelper.getCorrectTemperature(from: firstDayTemperature.temperature.minTemp)))
                case .maxTemp:
                    resultArray.append(DetailWeatherViewModel(name: $0.detailWeather,
                                                              value: measurementHelper.getCorrectTemperature(from: firstDayTemperature.temperature.maxTemp)))
                }
            }
        }
        // swiftlint:enable line_length

        return resultArray
    }

    func getCurrentWeatherModel(from networkModel: CurrentWeatherData, with name: String) -> MainCurrentWeatherViewModel {
        let dateString = measurementHelper.getFullDate(with: Double(networkModel.date))
        let sunrise = measurementHelper.getOnlyTimeDate(with: networkModel.sunrise)
        let sunset = measurementHelper.getOnlyTimeDate(with: networkModel.sunset)
        let temperature = measurementHelper.getCorrectTemperature(from: networkModel.temperature)

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
}

// MARK: - Helpers
private extension DataManager {
    func getConditionName(by id: Int) -> String {
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

    func getDailyViewModel(from networkModel: DailyWeatherData) -> DailyDetailWeatherModel {
        let dayString = measurementHelper.getOnlyDayDate(with: Double(networkModel.date))

        let temperature = measurementHelper.getCorrectTemperature(from: networkModel.temperature.daily)

        guard let weather = networkModel.weather.first else {
            fatalError()
        }

        let condtitionName = getConditionName(by: weather.id)

        return DailyDetailWeatherModel(dayName: dayString, temperature: temperature, conditionName: condtitionName)
    }

    func getHoursViewModel(from networkModel: HourlyWeatherData) -> HoursWeatherViewModel {
        let temperature = measurementHelper.getCorrectTemperature(from: networkModel.temperature)

        let timeString = measurementHelper.getOnlyTimeDate(with: Double(networkModel.date))

        guard let weather = networkModel.weather.first else {
            fatalError()
        }

        let conditionName = getConditionName(by: weather.id)

        return HoursWeatherViewModel(time: timeString, temperature: temperature, conditionName: conditionName)
    }

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
}
