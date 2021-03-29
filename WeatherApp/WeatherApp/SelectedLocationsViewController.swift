//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit
import CoreLocation

class SelectedLocationsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet private weak var contentTableView: UITableView!
    
    //MARK: - Private Properties
    private var dataSource: [SelectedLocationWeatherModel] = DataManager.instance.getDataSourceModelArray(from: DataBaseManager.instance.getCities())
    private var currentLocationButton: UIButton?
    private let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableview()
        makeAddButton()
        makeCurrentLocationButton()
        loadAll()
        configureRefreshControl()
        styleUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //MARK: - Actions
    @objc func addButtonTapped(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        destinationVC.delegate = self
        destinationVC.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func currentLocationButtonTapped(_ sender: UIButton) {
        guard dataSource[0].cityName != "Current Location" else {
            return
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @objc func handleRefreshControl() {
        loadAll()
        
        DispatchQueue.main.async {
            self.contentTableView.refreshControl?.endRefreshing()
        }
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DispatchQueue.main.async {
                DataBaseManager.instance.delete(city: DataBaseManager.instance.getCities()[indexPath.row])
                self.dataSource.remove(at: indexPath.row)
                self.contentTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

//MARK: - Helpers
private extension SelectedLocationsViewController {
    func setUpTableview() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "SelectedLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedLocationTableViewCell")
    }
    
    func makeAddButton() {
        let button = UIButton(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 120, width: 80, height: 80))
        button.setTitle("Add", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = button.frame.width / 2
        
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func makeCurrentLocationButton() {
        currentLocationButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 120, width: 80, height: 80))
        
        guard let currentLocationButton = currentLocationButton else { return }
        
        currentLocationButton.setTitle("Current", for: .normal)
        currentLocationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        currentLocationButton.setTitleColor(.white, for: .normal)
        currentLocationButton.backgroundColor = .black
        currentLocationButton.layer.cornerRadius = 40
        
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(currentLocationButton)
    }
    
    func styleUI() {
        contentTableView.backgroundColor = .clear
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        
        layer.colors = [UIColor(named: "TopBackgroundColor")?.cgColor, UIColor(named: "BottomBackgroundColor")?.cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.addSublayer(layer)
    }
    
    func loadAll() {
        for i in 0..<dataSource.count {
            dataSource[i].temperature = nil
        }
        
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
        
        for item in dataSource {
            var networkManager = SelectedLocationWeatherManager()
            networkManager.delegate = self
            networkManager.fetchWeatherBy(coordinates: (longitude: item.longtitude, latitude: item.lattitude))
        }
    }
    
    func configureRefreshControl () {
        contentTableView.refreshControl = UIRefreshControl()
        contentTableView.refreshControl?.addTarget(self, action:
                                                    #selector(handleRefreshControl),
                                                   for: .valueChanged)
    }
}

//MARK: - Network Delegate
extension SelectedLocationsViewController: SelectedLocationWeatherManagerDelegate {
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didUpdateWeather weather: Double, at location: (long: Double, lat: Double)) {
        for i in 0..<dataSource.count {
            if dataSource[i].lattitude == location.lat, dataSource[i].longtitude == location.long {
                DispatchQueue.main.async {
                    self.dataSource[i].temperature = weather
                    self.contentTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
                }
                break
            }
        }
    }
    
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetCityName name: String, at location: (long: Double, lat: Double)) {
        DataBaseManager.instance.addCity(latitude: location.lat, longitude: location.long, name: name)
        dataSource = DataManager.instance.getDataSourceModelArray(from: DataBaseManager.instance.getCities())
        loadAll()
    }
    
    func didFailWithError(error: Error) {
        fatalError("Fail with error")
    }
}

//MARK: - MapViewController Delegate Methods
extension SelectedLocationsViewController: MapViewControllerDelegate {
    func mapViewController(didAddLocation: (longitude: Double?, latitude: Double?)) {
        if let lon = didAddLocation.longitude, let lat = didAddLocation.latitude {
            var networkManager = SelectedLocationWeatherManager()
            networkManager.delegate = self
            networkManager.getCityName(by: (lon, lat))
        }
    }
}

//MARK: - CLLocationManager Delegate Methods

extension SelectedLocationsViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            dataSource.insert(SelectedLocationWeatherModel(cityName: "Current Location", temperature: nil, longtitude: lon, lattitude: lat), at: 0)
            
            DispatchQueue.main.async {
                self.contentTableView.beginUpdates()
                self.contentTableView.insertRows(at: [IndexPath(row: self.dataSource.count - 1, section: 0)], with: .fade)
                self.contentTableView.endUpdates()
                self.loadAll()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
