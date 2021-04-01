//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func mapViewController(_ sender: MapViewController,
                           didAddLocation: (longitude: Double?,
                                            latitude: Double?))
}

class MapViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!

    // MARK: - Private Properties
    private var tapRecognizer: UITapGestureRecognizer?
    private var longitude: Double?
    private var latitude: Double?
    private var resultSearchController: UISearchController?

    // MARK: - Public Properties
    weak var delegate: MapViewControllerDelegate?

    // MARK: - VC LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        styleUI()
        setUpTapGestureRecognizer()
        setUpSearchController()
    }

    deinit {
        mapView.removeAnnotations(mapView.annotations)
    }

    // MARK: - Actions
    @objc func addButtonTapped(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else { return }

        if DataBaseManager.instance.isSelected(latitude: latitude, longitude: longitude) {
            showAlreadyAddedAlert()
            return
        }

        delegate?.mapViewController(self, didAddLocation: (longitude: longitude, latitude: latitude))

        navigationController?.popViewController(animated: true)
    }

    @objc func didTapOnMap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchMapCoordinate.latitude,
                                  longitude: touchMapCoordinate.longitude)

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let error = error {
                fatalError("\(error)")
            }

            var placeMark: CLPlacemark!

            guard let placemarks = placemarks, !placemarks.isEmpty else {
                self.showEmptyResponseAlert()
                return
            }

            placeMark = placemarks[0]

            if let city = placeMark.subAdministrativeArea {
                DispatchQueue.main.async {
                    self.addPinOnMap(pinLatitude: touchMapCoordinate.latitude,
                                     pinLongitude: touchMapCoordinate.longitude)
                    self.resultSearchController?.searchBar.text = String(city)
                }
            } else {
                DispatchQueue.main.async {
                    self.resultSearchController?.searchBar.text = ""
                    self.resultSearchController?.searchBar.placeholder = NSLocalizedString("find_city_name_error", comment: "")
                }
            }
        })
    }
}

// MARK: - Helpers
private extension MapViewController {
    func styleUI() {
        addButton()
    }

    func addButton() {
        let button = UIButton(frame: CGRect(x: (view.frame.width / 2) - 100,
                                            y: view.frame.height - 100,
                                            width: 200,
                                            height: 40))
        button.setTitle(NSLocalizedString("add_button_title", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20

        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    func setUpTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnMap(_:)))
        tapRecognizer = tapGestureRecognizer
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    func setUpSearchController() {
        guard let locationSearchTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTableViewController else { return }

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("city_search_placeholder", comment: "")
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable.handleMapSearchDelegate = self
    }

    func addPinOnMap(pinLatitude: Double, pinLongitude: Double) {
        longitude = pinLongitude
        latitude = pinLatitude

        mapView.removeAnnotations(mapView.annotations)

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pinLatitude,
                                                                       longitude: pinLongitude),
                                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

        mapView.setRegion(region, animated: true)

        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = CLLocationCoordinate2D(latitude: pinLatitude, longitude: pinLongitude)
        mapView.addAnnotation(mapAnnotation)
    }

    func showEmptyResponseAlert() {
        let alert = UIAlertController(title: NSLocalizedString("empty_response_alert_title", comment: ""),
                                      message: NSLocalizedString("empty_response_alert_message", comment: ""),
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showAlreadyAddedAlert() {
        let alert = UIAlertController(title: NSLocalizedString("already_exists_title", comment: ""),
                                      message: NSLocalizedString("already_exists_message", comment: ""),
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - MapSearchDelegate Methods
extension MapViewController: MapSearchDelegate {
    func mapSearchDelegate(didSelectItem item: String) {
        DispatchQueue.main.async {
            self.resultSearchController?.searchBar.text = item
        }

        let networkManager = WeatherNetworkManager()
        networkManager.getCoordinates(by: item.replacingOccurrences(of: " ", with: "+")) { (coordinates, error) in
            if let error = error {
                fatalError("\(error)")
            }

            guard let coordinates = coordinates else {
                DispatchQueue.main.async {
                    self.showEmptyResponseAlert()
                }
                return
            }

            DispatchQueue.main.async {
                self.addPinOnMap(pinLatitude: coordinates.latitude, pinLongitude: coordinates.longitude)
            }
        }
    }
}
