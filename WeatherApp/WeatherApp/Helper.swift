//
//  Helper.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 12.04.2021.
//

import Foundation

class Helper {
    private let dateFormater = DateFormatter()
    private let fullDateFormat = "EEEE, MMM d, yyyy"
    private let onlyTimeFormat = "HH:mm"
    private let onlyDayFormat = "EEEE"

    func getFullDate(with unixDate: Double) -> String {
        return getDate(from: unixDate, with: fullDateFormat).capitalized
    }

    func getOnlyDayDate(with unixDate: Double) -> String {
        return getDate(from: unixDate, with: onlyDayFormat).capitalized
    }

    func getOnlyTimeDate(with unixDate: Double) -> String {
        return getDate(from: unixDate, with: onlyTimeFormat)
    }

    private func getDate(from unixDate: Double, with dateFormat: String) -> String {
        let date = Date(timeIntervalSince1970: unixDate)
        dateFormater.dateFormat = dateFormat
        return dateFormater.string(from: date)
    }
}
