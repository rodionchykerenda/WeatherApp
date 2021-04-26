//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit
import CoreLocation

class SelectedLocationsViewController: UIViewController, StoryboardLoadable {
    // MARK: - Outlets
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var contentTableView: UITableView!

    // MARK: - Private Properties
    private let dataManager = DataManager.instance
    private let dataBaseManager = DataBaseManager.instance
    private let measurementHelper = UnitMeasurementHelper()
    private var gradientLayer = CAGradientLayer()

    private var dataSource: [WeatherModel] = []

    private var currentLocationButton: UIButton?
    private let locationManager = CLLocationManager()

    // MARK: - Public Properties
    var onSelectDetailWeather: (() -> Void)?
    var onSelectAddButton: (() -> Void)?
    var onSelectSettingsButton: (() -> Void)?

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpData()
        setUpDelegates()
        loadAllWeathers()
        styleUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dataBaseManager.deleteAllLocations()
        StorageManager.instance.reset()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Actions
    @objc func addButtonTapped(_ sender: UIButton) {
        onSelectAddButton?()
    }

    @objc func currentLocationButtonTapped(_ sender: UIButton) {
        guard !dataSource.isEmpty else {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()

            return
        }

        guard dataSource[0] as? CurrentLocationWeatherModel == nil else {
            return
        }

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    @objc func settingsButtonTapped(_ sender: UIButton) {
        onSelectSettingsButton?()
    }

    @objc func handleRefreshControl() {
        if dataSource.isEmpty {
            contentTableView.refreshControl?.endRefreshing()
        } else {
            loadAllWeathers {
                self.contentTableView.refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: - TableView Delegate And DataSource Methods
extension SelectedLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(for: indexPath, cellType: SelectedLocationTableViewCell.self)

        cell.update(selectedLocation: dataSource[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DispatchQueue.main.async {
                // swiftlint:disable line_length
                if self.dataSource[indexPath.row] as? CurrentLocationWeatherModel == nil {
                    self.dataBaseManager.delete(city: DataManager.instance.isContainedCurrentLocation(in: self.dataSource) ? self.dataBaseManager.getCities()[indexPath.row - 1] : self.dataBaseManager.getCities()[indexPath.row])
                }
                // swiftlint:enable line_length

                self.dataSource.remove(at: indexPath.row)
                self.contentTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataBaseManager.addLocation(latitude: dataSource[indexPath.row].lattitude,
                                    longitude: dataSource[indexPath.row].longtitude,
                                    name: dataSource[indexPath.row].cityName)

        onSelectDetailWeather?()
    }
}

// MARK: - Helpers
private extension SelectedLocationsViewController {
    func setUpDelegates() {
        setUpTableview()
        configureRefreshControl()
        setUpLocationManager()
    }

    func setUpData() {
        dataSource = dataManager.getDataSourceModelArray(from: dataBaseManager.getCities())
    }

    func setUpTableview() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(cellType: SelectedLocationTableViewCell.self)
    }

    func setUpLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    func makeAddButton() {
        let button = UIButton()

        button.setTitle(NSLocalizedString("add_button_title", comment: ""), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red

        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                      constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                       constant: -40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true

        button.layer.cornerRadius = 40
    }

    func makeSettingsButton() {
        let button = UIButton()

        button.setTitle(NSLocalizedString("settings", comment: ""), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray

        button.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                     constant: 20).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                       constant: -140).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true

        button.layer.cornerRadius = 40
    }

    func makeCurrentLocationButton() {
        currentLocationButton = UIButton()

        guard let currentLocationButton = currentLocationButton else { return }

        currentLocationButton.setTitle(NSLocalizedString("current_button_title", comment: ""), for: .normal)
        currentLocationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        currentLocationButton.setTitleColor(.white, for: .normal)
        currentLocationButton.backgroundColor = .black

        currentLocationButton.addTarget(self,
                                        action: #selector(currentLocationButtonTapped(_:)),
                                        for: .touchUpInside)
        view.addSubview(currentLocationButton)
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                    constant: 20).isActive = true
        currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                      constant: -40).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        currentLocationButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

        currentLocationButton.layer.cornerRadius = 40
    }

    func styleUI() {
        contentTableView.backgroundColor = .clear
        gradientLayer.frame = view.bounds

        if let topColor = UIColor(named: String.topColor)?.cgColor,
           let bottomColor = UIColor(named: String.bottomColor)?.cgColor {
            gradientLayer.colors = [topColor, bottomColor]
        }

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.addSublayer(gradientLayer)

        makeAddButton()
        makeCurrentLocationButton()
        makeSettingsButton()
    }

    func loadAllWeathers(completionHandler: @escaping () -> Void = {}) {
        for index in 0..<dataSource.count {
            dataSource[index].temperature = nil
        }

        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }

        var weathersLoaded = 0

        dataSource.forEach {
            let networkManager = WeatherNetworkManager()
            networkManager.getTemperatureBy(coordinates: (longitude: $0.longtitude,
                                                          latitude: $0.lattitude)) { (temperature, coordinates, error) in
                if let error = error {
                    fatalError("\(error)")
                }

                guard let coordinates = coordinates, let temperature = temperature else {
                    fatalError()
                }

                let correctWeather = self.measurementHelper.getCorrectTemperature(from: temperature)

                for index in 0..<self.dataSource.count
                where self.dataSource[index].lattitude == coordinates.lat &&
                    self.dataSource[index].longtitude == coordinates.long {
                    DispatchQueue.main.async {
                        weathersLoaded += 1

                        self.dataSource[index].temperature = correctWeather
                        self.contentTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)

                        if weathersLoaded == self.dataSource.count {
                            completionHandler()
                            weathersLoaded = 0
                        }
                    }
                    break
                }
            }
        }
    }

    func configureRefreshControl () {
        contentTableView.refreshControl = UIRefreshControl()
        contentTableView.refreshControl?.addTarget(self,
                                                   action: #selector(handleRefreshControl),
                                                   for: .valueChanged)
    }
}

// MARK: - MapViewController Updated Methods
extension SelectedLocationsViewController: UpdatableWithLocation {
    func didSelectOnMap(location: (longitude: Double?, latitude: Double?)) {
        guard let longitude = location.longitude, let latitude = location.latitude else {
            return
        }

        let networkManager = WeatherNetworkManager()

        networkManager.getCityName(with: (longitude: longitude,
                                          latitude: latitude)) { (cityName, coordinates, error) in
            if let error = error {
                fatalError("\(error)")
            }

            guard let coordinates = coordinates, let cityName = cityName else {
                fatalError()
            }

            self.dataBaseManager.addCity(latitude: coordinates.lat,
                                         longitude: coordinates.long,
                                         name: cityName)

            if DataManager.instance.isContainedCurrentLocation(in: self.dataSource) {
                self.dataSource.removeSubrange(1..<self.dataSource.count)
                self.dataSource.append(contentsOf:
                                        DataManager.instance.getDataSourceModelArray(from:
                                                                                        self.dataBaseManager.getCities()))
            } else {
                self.dataSource = DataManager.instance.getDataSourceModelArray(from: self.dataBaseManager.getCities())
            }

            self.loadAllWeathers()
        }
    }
}

// MARK: - CLLocationManager Delegate Methods
extension SelectedLocationsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let currentLocation = CurrentLocationWeatherModel(longtitude: longitude, lattitude: latitude)

        DispatchQueue.main.async {
            self.contentTableView.beginUpdates()
            self.dataSource.insert(currentLocation, at: 0)
            self.contentTableView.insertRows(at: [IndexPath(row: self.dataSource.count - 1, section: 0)],
                                             with: .fade)
            self.contentTableView.endUpdates()
            self.loadAllWeathers()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - Dark/Light Mode Appearance
extension SelectedLocationsViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
                return
            }

            if let topColor = UIColor(named: String.topColor)?.cgColor,
               let bottomColor = UIColor(named: String.bottomColor)?.cgColor {
                gradientLayer.colors = [topColor, bottomColor]
            }
        }
    }
}
