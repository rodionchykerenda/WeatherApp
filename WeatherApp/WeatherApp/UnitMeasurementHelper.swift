//
//  UnitMeasurementHelper.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 12.04.2021.
//

import Foundation

class UnitMeasurementHelper {
    private let dateFormater = DateFormatter()
    private let fullDateFormat = "EEEE, MMM d, yyyy"
    private let onlyTimeFormat24 = "HH:mm"
    private let onlyTimeFormat12 = "h:mm a"
    private let onlyDayFormat = "EEEE"
    private let unitMeasurementManager = UnitMeasurementManager.instance

    // MARK: - Getters
    func getFullDate(with unixDate: Double) -> String {
        return getDate(from: unixDate, with: fullDateFormat).capitalized
    }

    func getOnlyDayDate(with unixDate: Double) -> String {
        return getDate(from: unixDate, with: onlyDayFormat).capitalized
    }

    func getOnlyTimeDate(with unixDate: Double) -> String {
        if unitMeasurementManager.hours == .twentyFour {
            dateFormater.dateFormat = onlyTimeFormat24
        } else {
            dateFormater.dateFormat = onlyTimeFormat12
        }

        let date = Date(timeIntervalSince1970: unixDate)
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormater.string(from: date)
    }

    func getCorrectTemperature(from celcius: Double) -> String {
        if unitMeasurementManager.metrics == .farenheit {
            return String(format: "%.0f",
                          (celcius * Double.toFarenheitMultiplier) + Double.toFarenheitConstant) + String.farenheit
        }

        return String(format: "%.0f", celcius) + String.celcius
    }

    func getCorrectDistanceMeasurement(from speed: Double) -> String {
        if unitMeasurementManager.distance == .metres {
            return String(format: "%.0f", speed) + NSLocalizedString("metre_per_second", comment: "")
        }

        return String(format: "%.0f", speed * Double.toMilesPerHourMultiplier) + NSLocalizedString("miles_per_hours", comment: "")
    }

    // MARK: - Helpers
    private func getDate(from unixDate: Double, with dateFormat: String) -> String {
        let date = Date(timeIntervalSince1970: unixDate)
        dateFormater.dateFormat = dateFormat
        return dateFormater.string(from: date)
    }
}
