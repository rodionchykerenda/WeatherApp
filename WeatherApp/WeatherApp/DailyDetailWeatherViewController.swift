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

        dataSource = DataManager.instance.getDailyWeatherViewModelArray(from: globalWeather.daily)

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
        contentTableView.register(UINib(nibName: "DailyDetailTableViewCell",
                                        bundle: nil),
                                  forCellReuseIdentifier: "DailyDetailTableViewCell")
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
        backView.layer.addSublayer(layer)
    }
}

// MARK: - TableView Delegate And DataSource Methods
extension DailyDetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable line_length
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyDetailTableViewCell", for: indexPath) as? DailyDetailTableViewCell else {
            // swiftlint:enable line_length
            fatalError()
        }

        cell.update(with: dataSource[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
