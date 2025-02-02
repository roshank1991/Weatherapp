//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Rosh on 31/01/25.
//

import UIKit
import MapKit

protocol SearchCityDelegate: AnyObject {
    func didSelectCity(_ city: String)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKLocalSearchCompleterDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    weak var delegate: SearchCityDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        
        searchBar.returnKeyType = .default
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if Reachability.shared.isConnectedToNetwork() {
        
        searchCompleter.queryFragment = searchText
        }
        else{
            showNoInternetAlert()
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()  // Dismiss keyboard
            print("User pressed Return with text: \(searchBar.text ?? "")")
        }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResults[indexPath.row].title
        delegate?.didSelectCity(selectedCity)
        dismiss(animated: true)
    }
    
    func showNoInternetAlert() {
            let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        
        }
}
