//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit

class SelectedLocationsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    
    //MARK: - Private Properties
    private var networkManager = SelectedLocationWeatherManager()
    private var dataSource = [SelectedLocationWeatherModel]() {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableview()
        networkManager.delegate = self
        networkManager.fetchWeather(cityName: "London")
        networkManager.fetchWeather(cityName: "Paris")
        networkManager.fetchWeather(cityName: "Milan")
        contentTableView.reloadData()
    }
}

//MARK: - TableView Delegate And DataSource Methods
extension SelectedLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedLocationTableViewCell", for: indexPath) as? SelectedLocationTableViewCell else { fatalError("Couldnt dequeue reusable cell") }
        
        cell.update(selectedLocation: dataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - Helpers
private extension SelectedLocationsViewController {
    func setUpTableview() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "SelectedLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedLocationTableViewCell")
    }
}

//MARK: - Network Delegate
extension SelectedLocationsViewController: SelectedLocationWeatherManagerDelegate {
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didUpdateWeather weather: SelectedLocationWeatherModel) {
        DispatchQueue.main.async {
            self.dataSource.append(weather)
        }
    }
    
    func didFailWithError(error: Error) {
        fatalError("Fail with error")
    }
}
