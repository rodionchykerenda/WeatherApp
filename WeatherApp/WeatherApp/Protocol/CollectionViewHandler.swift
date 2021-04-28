//
//  CollectionViewHandler.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 27.04.2021.
//

import UIKit

protocol CollectionViewHandler: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var dataSource: [CollectionViewModel] { get set }

    func setDataSource(with array: [CollectionViewModel])
}

extension CollectionViewHandler {
    func setDataSource(with array: [CollectionViewModel]) {
        dataSource = array
    }
}
