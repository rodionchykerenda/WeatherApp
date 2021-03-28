//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 24.03.2021.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func mapViewController(didAddLocation: (longitude: Double?, latitude: Double?))
}

class MapViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!
    
    //MARK: - Private Properties
    private var tapRecognizer: UITapGestureRecognizer?
    private var longitude: Double?
    private var latitude: Double?
    private var resultSearchController: UISearchController? = nil
    
    //MARK: - Public Properties
    weak var delegate: MapViewControllerDelegate?
    
    //MARK: - VC LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        setUpTapGestureRecognizer()
        setUpSearchController()
    }
    
    //MARK: - Actions
    @objc func addButtonTapped(_ sender: UIButton) {
        delegate?.mapViewController(didAddLocation: (longitude: longitude, latitude: latitude))
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnMap(_ sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        print("tapGestureHandler: touchMapCoordinate = \(touchMapCoordinate.latitude),\(touchMapCoordinate.longitude)")
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
            
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                DispatchQueue.main.async {
                    self.addPinOnMap(lat: touchMapCoordinate.latitude, lon: touchMapCoordinate.longitude)
                    self.resultSearchController?.searchBar.text = String(city)
                }
            } else {
                DispatchQueue.main.async {
                    self.resultSearchController?.searchBar.text = ""
                    self.resultSearchController?.searchBar.placeholder = "Couldn't find city name. Try to selecet closer."
                }
            }
        })
    }
}

//MARK: - Helpers
private extension MapViewController {
    
    func styleUI() {
        addButton()
    }
    
    func addButton() {
        let button = UIButton(frame: CGRect(x: (view.frame.width / 2) - 100, y: view.frame.height - 100, width: 200, height: 40))
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func setUpTapGestureRecognizer() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnMap(_:)))
        if let tapRecognizer = tapRecognizer {
            mapView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func setUpSearchController() {
        guard let locationSearchTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTableViewController else { return }
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func addPinOnMap(lat: Double, lon: Double) {
        longitude = lon
        latitude = lat
        
        mapView.removeAnnotations(mapView.annotations)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        mapView.setRegion(region, animated: true)
        
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(mapAnnotation)
    }
    
    func showEmptyResponseAlert() {
        let alert = UIAlertController(title: "Empty response", message: "Sorry, we dont have this place in our DataBase. Try to find some other places close to this location.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - MapSearchDelegate Methods
extension MapViewController: MapSearchDelegate {
    func mapSearchDelegate(didSelectItem item: String) {
        DispatchQueue.main.async {
            self.resultSearchController?.searchBar.text = item
        }
        
        var networkManager = SelectedLocationWeatherManager()
        networkManager.delegate = self
        networkManager.getLocation(by: item.replacingOccurrences(of: " ", with: "+"))
    }
}

//MARK: - NetworkManager Delegate
extension MapViewController: SelectedLocationWeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print("error")
    }
    
    func selectedLocationWeatherManager(_ weatherManager: SelectedLocationWeatherManager, didGetLocation: (long: Double, lat: Double)) {
        DispatchQueue.main.async {
            self.addPinOnMap(lat: didGetLocation.lat, lon: didGetLocation.long)
        }
    }
    
    func didRecieveEmptyResponse() {
        DispatchQueue.main.async {
            self.showEmptyResponseAlert()
        }
    }
}
