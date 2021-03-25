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
        addButton()
        networkManager.delegate = self
        styleUI()
//        networkManager.fetchWeather(cityName: "London")
//        networkManager.fetchWeather(cityName: "Paris")
//        networkManager.fetchWeather(cityName: "Milan")
//        contentTableView.reloadData()
    }
    
    //MARK: - Actions
    @objc func addButtonTapped(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        destinationVC.delegate = self
        
        navigationController?.pushViewController(destinationVC, animated: true)
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
    
    func addButton() {
        let button = UIButton(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 100, width: 50, height: 50))
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = button.frame.width / 2
        
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func styleUI() {
        view.backgroundColor = .clear
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        
        layer.colors = [UIColor.green.cgColor, UIColor.yellow.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
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

//MARK: - MapViewController Delegate Methods
extension SelectedLocationsViewController: MapViewControllerDelegate {
    func mapViewController(didAddLocation: (longitude: Double?, latitude: Double?)) {
        if let lon = didAddLocation.longitude, let lat = didAddLocation.latitude {
            networkManager.fetchWeatherBy(coordinates: (longitude: lon, latitude: lat))
        }
    }
}
