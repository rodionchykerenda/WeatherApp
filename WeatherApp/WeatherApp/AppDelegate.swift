//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit
import CoreData

// swiftlint:disable private_over_fileprivate
fileprivate let dataBaseManager = DataBaseManager.instance
fileprivate let detailWeatherManager = DetailWeatherManager.instance
fileprivate let unitMeasurementManager = UnitMeasurementManager.instance
fileprivate let dataManager = DataManager.instance
// swiftlint:enable private_over_fileprivate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureSettings()

        return didStart()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func didStart() -> Bool {
        let navController = UINavigationController()

        mainCoordinator = AppCoordinator(router: ConcreteRouter(navController: navController))

        mainCoordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

    private func configureSettings() {
        guard let settingsMeasurement = dataBaseManager.getUnits().last,
              let hours = settingsMeasurement.hours,
              let distance = settingsMeasurement.distance,
              let metrics = settingsMeasurement.metrics else {
            return
        }

        unitMeasurementManager.hours = dataManager.getTimeFormat(from: hours)
        unitMeasurementManager.distance = dataManager.getDistanceMeasurement(from: distance)
        unitMeasurementManager.metrics = dataManager.getTemperatureMeasurement(from: metrics)

        guard !dataBaseManager.getAdditionalWeatherAttributes().isEmpty else {
            return
        }

        detailWeatherManager.detailWeatherToPresent.removeAll()

        dataBaseManager.getAdditionalWeatherAttributes().forEach {
            // swiftlint:disable line_length
            detailWeatherManager.detailWeatherToPresent.append(DetailWeatherSelection(detailWeather: dataManager.getDetailWeatherEnum(by: $0.weatherAttributeName ?? ""), isSelected: $0.isSelected))
            // swiftlint:enable line_length
        }
    }
}
