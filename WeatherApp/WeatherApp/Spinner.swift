//
//  Spinner.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 06.04.2021.
//

import UIKit

protocol Spinner: UIViewController {
    var loaderView: UIView? { get set }

    func showSpinner()
    func removeSpinner()
}

extension Spinner {
    func showSpinner() {
        loaderView = UIView(frame: self.view.bounds)
        loaderView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

        let activityIndicator = UIActivityIndicatorView(style: .large)

        guard let loaderView = loaderView else { return }

        activityIndicator.center = loaderView.center
        activityIndicator.startAnimating()
        loaderView.addSubview(activityIndicator)
        self.view.addSubview(loaderView)
    }

    func removeSpinner() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}
