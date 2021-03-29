//
//  LocationSearchTableViewController.swift
//  WeatherApp
//
//  Created by Rodion Chykerenda on 25.03.2021.
//

import UIKit
import MapKit

protocol MapSearchDelegate: class {
    func mapSearchDelegate(didSelectItem item: String)
}

class LocationSearchTableViewController: UITableViewController, MKLocalSearchCompleterDelegate {
    
    weak var handleMapSearchDelegate: MapSearchDelegate?
    
    var searchTerms: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var completer: MKLocalSearchCompleter = MKLocalSearchCompleter()
    
    func searchFor(term: String) {
        completer.delegate = self
        completer.region = MKCoordinateRegion(.world)
        completer.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        completer.queryFragment = term
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.filter { result in
            guard result.title.contains(",") || !result.subtitle.isEmpty else { return false }
            guard !result.subtitle.contains("Nearby") else { return false }
            guard !result.title.contains("Street"), !result.title.contains("Square") else { return false }
            return true
        }
        
        self.searchTerms = results.map { $0.title.components(separatedBy: ",")[0] }
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        
        guard searchController.searchBar.text != "" else {
            searchTerms = []
            return
        }
        searchFor(term: searchBarText)
    }
}

extension LocationSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = searchTerms[indexPath.row]
        cell.textLabel?.text = selectedItem
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchTerms[indexPath.row]
        handleMapSearchDelegate?.mapSearchDelegate(didSelectItem: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
