//
//  DataBaseManager.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit
import CoreData

class DataBaseManager {
    static let instance = DataBaseManager()

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - CRUD for SelectedCity
    func getCities() -> [SelectedCity] {
        let request: NSFetchRequest<SelectedCity> = SelectedCity.fetchRequest()
        var cities = [SelectedCity]()

        do {
            cities = try context.fetch(request)
        } catch {
            print("Error loading cities,\(error)")
        }
        return cities
    }

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }

    func addCity(latitude: Double, longitude: Double, name: String) {
        let newCity = SelectedCity(context: context)
        newCity.name = name
        newCity.latitude = NSNumber(value: latitude)
        newCity.longitude = NSNumber(value: longitude)
        saveData()
    }

    func isSelected(latitude: Double, longitude: Double) -> Bool {
        let cities = getCities()

        return !cities.filter {
            guard let selectedLongitude = $0.longitude,
               let selectedLatitude = $0.latitude,
               longitude == Double(truncating: selectedLongitude),
               latitude == Double(truncating: selectedLatitude) else {
                return false
            }

            return true
        }.isEmpty
    }

    func delete(city: SelectedCity) {
        context.delete(city)
        saveData()
    }

    // MARK: - CRUD for SelectedLocation
    func getLocations() -> [SelectedLocation] {
        let request: NSFetchRequest<SelectedLocation> = SelectedLocation.fetchRequest()
        var cities = [SelectedLocation]()

        do {
            cities = try context.fetch(request)
        } catch {
            print("Error loading cities,\(error)")
        }

        return cities
    }

    func addLocation(latitude: Double, longitude: Double, name: String) {
        let newLocation = SelectedLocation(context: context)
        newLocation.longitude = NSNumber(value: longitude)
        newLocation.latitude = NSNumber(value: latitude)
        newLocation.name = name
        saveData()
    }

    func deleteAllLocations() {
        let request: NSFetchRequest<SelectedLocation> = SelectedLocation.fetchRequest()
        request.returnsObjectsAsFaults = false

        do {
            let incidents = try context.fetch(request)

            guard !incidents.isEmpty else { return }

            incidents.forEach {
                self.context.delete($0)
            }

            try context.save()
        } catch {
            fatalError("Couldn't fetch delete request")
        }
    }

    // MARK: - CRUD for UnitMeasurement
    func getUnits() -> [UnitMeasurement] {
        let request: NSFetchRequest<UnitMeasurement> = UnitMeasurement.fetchRequest()
        var units = [UnitMeasurement]()

        do {
            units = try context.fetch(request)
        } catch {
            print("Error loading cities,\(error)")
        }

        return units
    }

    func addUnit(hours: String, distance: String, metrics: String) {
        let newUnit = UnitMeasurement(context: context)
        newUnit.hours = hours
        newUnit.distance = distance
        newUnit.metrics = metrics

        saveData()
    }

    func deleteAllUnits() {
        let request: NSFetchRequest<UnitMeasurement> = UnitMeasurement.fetchRequest()
        request.returnsObjectsAsFaults = false

        do {
            let incidents = try context.fetch(request)

            guard !incidents.isEmpty else { return }

            incidents.forEach {
                self.context.delete($0)
            }

            try context.save()
        } catch {
            fatalError("Couldn't fetch delete request")
        }
    }

    // MARK: - CRUD for AdditionalWeatherAttributes
    func getAdditionalWeatherAttributes() -> [AdditionalWeatherAttribute] {
        let request: NSFetchRequest<AdditionalWeatherAttribute> = AdditionalWeatherAttribute.fetchRequest()
        var attribute = [AdditionalWeatherAttribute]()

        do {
            attribute = try context.fetch(request)
        } catch {
            print("Error loading cities,\(error)")
        }

        return attribute
    }

    func addAttributes(_ attributes: [DetailWeatherSettingsViewModel]) {
        attributes.map {
            let newAttribute = AdditionalWeatherAttribute(context: context)
            newAttribute.weatherAttributeName = $0.name.rawValue
            newAttribute.isSelected = $0.isSelected

            saveData()
        }
    }

    func deleteAllAttributes() {
        let request: NSFetchRequest<AdditionalWeatherAttribute> = AdditionalWeatherAttribute.fetchRequest()
        request.returnsObjectsAsFaults = false

        do {
            let incidents = try context.fetch(request)

            guard !incidents.isEmpty else { return }

            incidents.forEach {
                self.context.delete($0)
            }

            try context.save()
        } catch {
            fatalError("Couldn't fetch delete request")
        }
    }
}
