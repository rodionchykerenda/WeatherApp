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
    private let storage = StorageManager.instance
    private let dataManager = DataManager.instance
    private let hoursCollectionHandler = HoursWeatherHandler()
    private let detailCollectionHandler = DetailWeatherHandler()
    private var mainCurrentWeatherModel: MainCurrentWeatherViewModel?
    private var dataSource: [DetailWeatherRowsViewModel] = [.main,
                                                            .hourly,
                                                            .detail]

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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Actions
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
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
        guard let globalWeather = storage.getGlobalWeatherData(), let cityName = selectedLocation?.name else { return }

        makeBackButton()

        mainCurrentWeatherModel = dataManager.getCurrentWeatherModel(from: globalWeather.current, with: cityName)

        hoursCollectionHandler.setDataSource(with: dataManager.getHoursWeatherViewModelArray(from: globalWeather.hourly))

        detailCollectionHandler.setDataSource(with: dataManager.getDetailWeatherViewModalArray(from: globalWeather))

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

        storage.attach(self)
        
        storage.getWeatherForLocationBy(longitude: Double(truncating: longitude),
                                        latitude: Double(truncating: latitude))
    }

    func setUpTableView() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(cellType: MainCurrentWeatherTableViewCell.self)
        contentTableView.register(cellType: HoursWeatherTableViewCell.self)
        contentTableView.register(cellType: DetailCurrentWeatherTableViewCell.self)
    }

    func styleUI() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds

        if let topColor = UIColor(named: String.topColor)?.cgColor,
           let bottomColor = UIColor(named: String.bottomColor)?.cgColor {
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
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.row] {
        case .main:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MainCurrentWeatherTableViewCell.self)

            cell.update(with: mainCurrentWeatherModel)
            return cell

        case .hourly:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HoursWeatherTableViewCell.self)

            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: hoursCollectionHandler)

            return cell

        case .detail:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DetailCurrentWeatherTableViewCell.self)

            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: detailCollectionHandler)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.row] {
        case .main:
            return 320
        case .hourly:
            return 170
        case .detail:
            guard !detailCollectionHandler.dataSource.isEmpty else { return 0 }

            print(Double(detailCollectionHandler.dataSource.count) / 2)
            let cellHeight = (Double(detailCollectionHandler.dataSource.count) / 2).rounded(.toNearestOrAwayFromZero) * 100
            let spacing = Double((dataSource.count / 2) * 20)
            return CGFloat(cellHeight + spacing)
        }
    }
}
