//
//  SelectedLocationWeatherManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import Foundation

protocol SelectedLocationWeatherManagerDelegate: class {
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didUpdateWeather weather: Double, at location: (long: Double, lat: Double))
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetLocation location: (long: Double, lat: Double))
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetCityName name: String, at location: (long: Double, lat: Double))
    
    func didFailWithError(error: Error)
    func didRecieveEmptyResponse()
}

extension SelectedLocationWeatherManagerDelegate {
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didUpdateWeather weather: Double, at location: (long: Double, lat: Double)){}
    
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetCityName name: String, at location: (long: Double, lat: Double)) {}
    
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetLocation location: (long: Double, lat: Double)) {}
    
    func didRecieveEmptyResponse() {}
}

struct SelectedLocationWeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=73894ed3d982502db57069e27afdfc6b&units=metric"
    
    weak var delegate: SelectedLocationWeatherManagerDelegate?
    
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
    
    func getLocation(by cityName: String) {
        let correctCityName = cityName.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(correctCityName)&limit=1&appid=73894ed3d982502db57069e27afdfc6b") {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([Coordinates].self, from: safeData)
                        guard decodedData.count > 0 else {
                            delegate?.didRecieveEmptyResponse()
                            return
                        }
                        delegate?.selectedLocationWeatherManager(self, didGetLocation: (long: decodedData[0].lon, lat: decodedData[0].lat))
                        return
                    } catch {
                        delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getCityName(by location: (longitude: Double, latitude: Double)) {
        if let url = URL(string: "https://api.openweathermap.org/geo/1.0/reverse?lat=\(location.latitude)&lon=\(location.longitude)&limit=1&appid=73894ed3d982502db57069e27afdfc6b") {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([CityName].self, from: safeData)
                        guard decodedData.count > 0 else {
                            delegate?.didRecieveEmptyResponse()
                            return
                        }
                        
                        delegate?.selectedLocationWeatherManager(self, didGetCityName: decodedData[0].name, at: (long: location.longitude, lat: location.latitude))
                        return
                    } catch {
                        delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchWeatherBy(coordinates: (longitude: Double, latitude: Double)) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=73894ed3d982502db57069e27afdfc6b&units=metric"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    fatalError()
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.selectedLocationWeatherManager(self, didUpdateWeather: weather, at: (long: coordinates.longitude, lat: coordinates.latitude))
                    }
                }
            }
            task.resume()
        }
    }
}
