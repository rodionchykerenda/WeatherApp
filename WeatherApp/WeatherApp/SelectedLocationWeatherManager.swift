//
//  SelectedLocationWeatherManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

protocol SelectedLocationWeatherManagerDelegate: class {
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didUpdateWeather weather: SelectedLocationWeatherModel)
    func didFailWithError(error: Error)
}

struct SelectedLocationWeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=73894ed3d982502db57069e27afdfc6b&units=metric"
    
    weak var delegate: SelectedLocationWeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performSelectedLocationRequest(with: urlString)
    }
    
    func performSelectedLocationRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.selectedLocationWeatherManager(self, didUpdateWeather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> SelectedLocationWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let longtitude = decodedData.coord.lon
            let lattitude = decodedData.coord.lat
            
            let weather = SelectedLocationWeatherModel(conditionId: id, cityName: name, temperature: temp, longtitude: longtitude, lattitude: lattitude)
            
            return weather
        } catch {
            print("Couldnt parse JSON")
            return nil
        }
    }
}
