//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit

class SelectedLocationsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet private weak var contentTableView: UITableView!
    
    //MARK: - Private Properties
    private var networkManager = SelectedLocationWeatherManager()
    private var dataSource = [SelectedLocationWeatherModel]() {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("VIEW DID LOAD")
        setUpTableview()
        addButton()
        networkManager.delegate = self
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
        let button = UIButton(frame: CGRect(x: view.frame.width - 100, y: view.frame.height - 120, width: 80, height: 80))
        button.setTitle("Add", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = button.frame.width / 2
        
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
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
}

//MARK: - Network Delegate
extension SelectedLocationsViewController: SelectedLocationWeatherManagerDelegate {
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didUpdateWeather weather: SelectedLocationWeatherModel) {
        DispatchQueue.main.async {
            self.dataSource.append(weather)
        }
    }
    
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetCityName name: String, at location: (long: Double, lat: Double)) {
        DispatchQueue.main.async {
            DataBaseManager.instance.addCity(latitude: location.lat, longitude: location.long, name: name)
//            dataSource = DataBaseManager.instance.getCities()
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
            networkManager.getCityName(by: (lon, lat))
            print("Delegate Method")
            //networkManager.fetchWeatherBy(coordinates: (longitude: lon, latitude: lat))
        }
    }
}
