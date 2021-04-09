//
//  DetailWeatherHandler.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 09.04.2021.
//

import UIKit

class DetailWeatherHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var dataSource = [DetailWeatherViewModel]()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable line_length
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailWeatherCollectionViewCell", for: indexPath) as? DetailWeatherCollectionViewCell else {
            fatalError()
        }
        // swiftlint:enable line_length

        cell.update(with: dataSource[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 20, height: collectionView.frame.size.height / 3 - 10)
    }
}
