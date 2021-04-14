//
//  DailyDetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 02.04.2021.
//

import UIKit

class DailyDetailWeatherViewController: UIViewController, LoadableView {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    @IBOutlet private weak var backView: UIView!

    // MARK: - Private Properties
    private let storage = StorageManager.instance
    private var dataSource = [DailyDetailWeatherModel]()
    private let dataManager = DataManager.instance

    // MARK: - Public Properties
    var loaderView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDelegates()
        styleUI()
        loadData()
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
        let layer = CAGradientLayer()
        layer.frame = view.bounds

        if let topColor = UIColor(named: String.topColor)?.cgColor,
           let bottomColor = UIColor(named: String.bottomColor)?.cgColor {
            layer.colors = [topColor, bottomColor]
        }

        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        backView.layer.addSublayer(layer)
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
