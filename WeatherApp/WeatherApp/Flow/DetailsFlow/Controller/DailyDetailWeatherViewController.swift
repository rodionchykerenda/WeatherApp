//
//  DailyDetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 02.04.2021.
//

import UIKit

class DailyDetailWeatherViewController: UIViewController, LoadableView, StoryboardLoadable {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    @IBOutlet private weak var backView: UIView!

    // MARK: - Private Properties
    private var storage: StorageManagerProtocol!
    private var dataSource = [DailyDetailWeatherModel]()
    private var dataManager: DetailWeatherDataManager!
    private var gradientLayer = CAGradientLayer()

    // MARK: - Public Properties
    var loaderView: UIView?

    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDelegates()
        styleUI()
        loadData()
    }

    // MARK: - Setters
    func setDataManager(_ manager: DetailWeatherDataManager) {
        dataManager = manager
    }

    func setStorage(_ manager: StorageManagerProtocol) {
        storage = manager
    }
}

// MARK: - Observer Methods
extension DailyDetailWeatherViewController: StorageObserver {
    func didGetUpdated(globalWeatherData: GlobalWeatherData?) {
        DispatchQueue.main.async {
            self.removeSpinner()
            self.updateUI()
        }
    }
}

// MARK: - Helpers
private extension DailyDetailWeatherViewController {
    func updateUI() {
        guard let globalWeather = storage.getGlobalWeatherData() else { return }

        dataSource = dataManager.getDailyWeatherViewModelArray(from: globalWeather.daily)

        contentTableView.reloadData()
    }

    func loadData() {
        storage.attach(self)

        guard !storage.isLoading else {
            showSpinner()
            return
        }

        DispatchQueue.main.async {
            self.updateUI()
        }
    }

    func setUpDelegates() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(cellType: DailyDetailTableViewCell.self)
    }

    func styleUI() {
        gradientLayer.frame = view.bounds

        if let topColor = UIColor(named: String.topColor)?.cgColor,
           let bottomColor = UIColor(named: String.bottomColor)?.cgColor {
            gradientLayer.colors = [topColor, bottomColor]
        }

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - TableView Delegate And DataSource Methods
extension DailyDetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: DailyDetailTableViewCell.self)

        cell.update(with: dataSource[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - Dark/Light Mode Appearance
extension DailyDetailWeatherViewController {
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
