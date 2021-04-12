//
//  DetailCurrentWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class DetailCurrentWeatherTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var contentCollectionView: UICollectionView!
    @IBOutlet private weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        styleUI()
    }

    // MARK: - Public Properties
    static let identifier = "DetailCurrentWeatherTableViewCell"

    func styleUI() {
        backView.layer.cornerRadius = 20
        backView.backgroundColor = UIColor(named: "BottomBackgroundColor")
    }
    // swiftlint:disable line_length
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout) {
        // swiftlint:enable line_length
        contentCollectionView.delegate = dataSourceDelegate
        contentCollectionView.dataSource = dataSourceDelegate
        contentCollectionView.register(UINib(nibName: String(describing: DetailWeatherCollectionViewCell.self), bundle: nil),
                                       forCellWithReuseIdentifier: DetailWeatherCollectionViewCell.identifier)
        contentCollectionView.reloadData()
    }
}
