//
//  HoursWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class HoursWeatherTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var contentCollectionView: UICollectionView!

    // swiftlint:disable line_length
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout) {
        // swiftlint:enable line_length
        contentCollectionView.delegate = dataSourceDelegate
        contentCollectionView.dataSource = dataSourceDelegate
        contentCollectionView.register(cellType: HoursWeatherCollectionViewCell.self)
        contentCollectionView.reloadData()
    }
}
