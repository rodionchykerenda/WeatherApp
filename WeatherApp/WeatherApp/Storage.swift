//
//  Storage.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 05.04.2021.
//

import Foundation

protocol StorageObserver: class {
    func update(storage: Storage)
}

class Storage {
    static let instance = Storage()

    private(set) var isLoading: Bool = false

    private lazy var observers = [StorageObserver]()

    var globalWeather: GlobalWeatherData?

    func attach(_ observer: StorageObserver) {
        observers.append(observer)
    }

    func detach(_ observer: StorageObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func notify() {
        observers.forEach({ $0.update(storage: self)})
    }

    func getWeatherForLocationBy(longitude: Double, latitude: Double) {
        setLoading()
        let networkManager = WeatherNetworkManager()
        networkManager.getDetailWeatherBy(longitude: longitude,
                                          latitude: latitude) { (weatherData, error) in
            guard let safeWeatherData = weatherData, error == nil else {
                self.globalWeather = nil

                return
            }

            self.globalWeather = safeWeatherData
            self.setLoading()
            self.notify()
        }
    }

    func reset() {
        isLoading = false
        observers.map {
            detach($0)
        }
    }

    func setLoading() {
        isLoading = !isLoading
    }
}
