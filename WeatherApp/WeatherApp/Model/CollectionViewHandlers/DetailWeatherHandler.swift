//
//  DetailWeatherHandler.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class DetailWeatherHandler: NSObject, CollectionViewHandler {
    var dataSource = [CollectionViewModel]()

    // MARK: - CollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DetailWeatherCollectionViewCell.self)

        guard let viewModel = dataSource[indexPath.row] as? DetailWeatherViewModel else {
            fatalError("Wrong model passed to the cell")
        }

        cell.update(with: viewModel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard !dataSource.isEmpty else {
            return CGSize(width: 0, height: 0)
        }
        
        return CGSize(width: collectionView.frame.size.width / 2 - 20, height: 100)
    }
}
