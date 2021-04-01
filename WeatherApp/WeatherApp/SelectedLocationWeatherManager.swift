//
//  WeatherNetworkManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

struct WeatherNetworkManager {
    private let appID = "&appid=73894ed3d982502db57069e27afdfc6b"
    private let session = URLSession(configuration: .default)
    private let preferredLanguage = NSLocale.preferredLanguages[0].components(separatedBy: "-")[0]

    func parseJSON(_ weatherData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            return temp
        } catch {
            print("Couldnt parse JSON")
            return nil
        }
    }

    func getCoordinates(by cityName: String, completionHandler: @escaping (Coordinates?, Error?) -> Void) {
        let cityName = cityName.replacingOccurrences(of: " ", with: "")
        let geoURL = "https://api.openweathermap.org/geo/1.0/"
        let limit = "&limit=1"
        let fullUrlString = "\(geoURL)direct?q=\(cityName)\(limit)\(appID)"

        guard let  encodedURL = fullUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let requestUrl = URL(string: encodedURL) else {
            return
        }

        let task = session.dataTask(with: requestUrl) { (data, _, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }

            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([Coordinates].self, from: safeData)
                    guard !decodedData.isEmpty else {
                        completionHandler(nil, nil)
                        return
                    }
                    completionHandler(decodedData[0], nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }

    func getCityName(with coordinates: (longitude: Double, latitude: Double),
                     completionHandler: @escaping (String?,
                                                   (long: Double, lat: Double)?,
                                                   Error?) -> Void) {
        let baseUrl = "https://api.openweathermap.org/geo/1.0/reverse?"

        guard let requestURL = URL(string: "\(baseUrl)lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&limit=1\(appID)") else {
            return
        }

        let task = session.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }

            guard let safeData = data else { return }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([CityName].self, from: safeData)

                guard !decodedData.isEmpty else {
                    completionHandler(nil, nil, nil)
                    return
                }

                if preferredLanguage == "ru" {
                    completionHandler(decodedData[0].localNames.russian,
                                      (long: coordinates.longitude,
                                       lat: coordinates.latitude),
                                      nil)
                } else {
                    completionHandler(decodedData[0].localNames.english,
                                      (long: coordinates.longitude,
                                       lat: coordinates.latitude),
                                      nil)
                }
            } catch {
                completionHandler(nil, nil, error)
            }
        }
        task.resume()
    }

    func getTemperatureBy(coordinates: (longitude: Double, latitude: Double),
                          completionHandler: @escaping (Double?,
                                                        (long: Double, lat: Double)?,
                                                        Error?) -> Void) {
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
        let metrics = "&units=metric"
        let urlString = "\(baseUrl)lat=\(coordinates.latitude)&lon=\(coordinates.longitude)\(appID)\(metrics)"

        guard let requestUrl = URL(string: urlString) else { return }

        let task = session.dataTask(with: requestUrl) { (data, _, error) in
            if let error = error {
                completionHandler(nil, nil, error)
            }

            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    completionHandler(weather,
                                      (long: coordinates.longitude, lat: coordinates.latitude),
                                      nil)
                }
            }
        }
        task.resume()
    }
}
