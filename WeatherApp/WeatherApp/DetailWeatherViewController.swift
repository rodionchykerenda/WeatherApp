//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 29.03.2021.
//

import UIKit

class DetailWeatherViewController: UIViewController, LoadableView {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    @IBOutlet private weak var backgroundView: UIView!

    // MARK: - Private Properties
    private let srotage = StorageManager.instance
    private let dataManager = DataManager.instance
    private let hoursCollectionHandler = HoursWeatherHandler()
    private let detailCollectionHandler = DetailWeatherHandler()

    private var mainCurrentWeatherModel: MainCurrentWeatherViewModel?

    // MARK: - Public Properties
    var selectedLocation: SelectedLocation?
    var loaderView: UIView?

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        styleUI()
        setUpTableView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Actions
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Observer Methods
extension DetailWeatherViewController: StorageObserver {
    func didGetUpdated(globalWeatherData: GlobalWeatherData?) {
        DispatchQueue.main.async {
            self.updateUI()
            self.removeSpinner()
        }
    }
}

// MARK: - Helpers
private extension DetailWeatherViewController {
    func updateUI() {
        guard let globalWeather = srotage.getGlobalWeatherData(), let cityName = selectedLocation?.name else { return }

        makeBackButton()

        mainCurrentWeatherModel = dataManager.getCurrentWeatherModel(from: globalWeather.current, with: cityName)

        hoursCollectionHandler.dataSource = dataManager.getHoursWeatherViewModelArray(from: globalWeather.hourly)

        detailCollectionHandler.dataSource = dataManager.getDetailWeatherViewModalArray(from: globalWeather)

        self.contentTableView.reloadData()
    }

    func makeBackButton() {
        let button = UIButton()

        button.setTitle(NSLocalizedString("back_button_title", comment: ""), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red

        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                      constant: 20).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: 5).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true

        button.layer.cornerRadius = 25
    }

    func loadData() {
        showSpinner()

        guard let longitude = selectedLocation?.longitude,
              let latitude = selectedLocation?.latitude else {
            return
        }

        srotage.attach(self)
        
        srotage.getWeatherForLocationBy(longitude: Double(truncating: longitude),
                                        latitude: Double(truncating: latitude))
    }

    func setUpTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "MainCurrentWeatherTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "MainCurrentWeatherTableViewCell")
        contentTableView.register(UINib(nibName: "HoursWeatherTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "HoursWeatherTableViewCell")
        contentTableView.register(UINib(nibName: "DetailCurrentWeatherTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "DetailCurrentWeatherTableViewCell")
    }

    func styleUI() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds

        if let topColor = UIColor(named: "TopBackgroundColor")?.cgColor,
           let bottomColor = UIColor(named: "BottomBackgroundColor")?.cgColor {
            layer.colors = [topColor, bottomColor]
        }

        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.addSublayer(layer)
    }
}

// MARK: - TableView Delegate And DataSource Methods
extension DetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // swiftlint:disable line_length
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCurrentWeatherTableViewCell", for: indexPath) as? MainCurrentWeatherTableViewCell else {
                // swiftlint:enable line_length
                fatalError()
            }

            cell.update(with: mainCurrentWeatherModel)
            return cell

        case 1:
            // swiftlint:disable line_length
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HoursWeatherTableViewCell", for: indexPath) as? HoursWeatherTableViewCell else {
                // swiftlint:enable line_length
                fatalError()
            }

            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: hoursCollectionHandler)

            return cell

        case 2:
            // swiftlint:disable line_length
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCurrentWeatherTableViewCell", for: indexPath) as? DetailCurrentWeatherTableViewCell else {
                // swiftlint:enable line_length
                fatalError()
            }
            
            if !srotage.isLoading {
                cell.styleUI()
            }

            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: detailCollectionHandler)

            return cell
            
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 320
        case 1:
            return 170
        case 2:
            return 320
        default:
            fatalError()
        }
    }
}
