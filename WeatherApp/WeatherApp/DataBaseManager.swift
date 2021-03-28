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
    
    
    //MARK: - Data Manipulation Methods
    func getCities() -> [SelectedCity] {
        let request: NSFetchRequest<SelectedCity> = SelectedCity.fetchRequest()
        var cities = [SelectedCity]()
        do {
            cities = try context.fetch(request)
        } catch {
            print("Error loading genres,\(error)")
        }
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        newCity.latitude = latitude
        newCity.longitude = longitude
        saveData()
    }
    
    func isSelected(latitude: Double, longitude: Double) -> Bool {
        let cities = getCities()
        for item in cities {
            if longitude == item.longitude, latitude == item.latitude {
                return true
            }
        }
        return false
    }
    
    func delete(city: SelectedCity) {
        context.delete(city)
        saveData()
    }
}
