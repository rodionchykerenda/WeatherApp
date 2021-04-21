//
//  HoursWeatherHandler.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class HoursWeatherHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private(set) var dataSource = [HoursWeatherViewModel]()

    // MARK: - Setters
    func setDataSource(with array: [HoursWeatherViewModel]) {
        dataSource = array
    }

    // MARK: - CollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HoursWeatherCollectionViewCell.self)

        cell.update(with: dataSource[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 150)
    }
}
