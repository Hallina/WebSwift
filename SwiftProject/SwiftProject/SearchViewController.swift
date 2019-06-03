//
//  Recherche.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbView: UITableView!
    
    let defaults = UserDefaults.standard
    
    var cities: [City]!
    var listFav: [City] = []
    
    var activeCity: City?
    let weatherClient = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9")
    
    var citiesName = [String]()
    var citiesID = [Int64]()
    var citiesCountry = [String]()
    var searching = false
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loaded()
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? DetailsViewController {
            searchDetail.query = self.activeCity
            searchDetail.listFav = self.listFav
        }
    }
    
    func save(listFav: [City]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(listFav) {
            defaults.set(encoded, forKey: "SavedFav")
        }
    }
    
    
    func loaded(){
        if let savedFav = defaults.object(forKey: "SavedFav") as? Data {
            let decoder = JSONDecoder()
            if let loadedFav = try? decoder.decode([City].self, from: savedFav) {
                listFav = loadedFav
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return citiesName.count
        }
        else {
            return 1
        }
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = citiesName[indexPath.row]
            cell?.detailTextLabel?.text = citiesCountry[indexPath.row]
        }
        else {
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        activeCity = cities[index]
        performSegue(withIdentifier: "cityWeather", sender: self)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // clean datas
        citiesName.removeAll()
        citiesID.removeAll()
        citiesCountry.removeAll()
        
        // search from the text entered
        cities = nil
        if (searchBar.text! != ""){
            cities = weatherClient.citiesSuggestions(for: searchBar.text!)
        }
        
        // prepare for table view
        for city in cities {
            citiesName.append(city.name)
            citiesID.append(city.identifier)
            citiesCountry.append(city.country)
        }
        
        searching = true
        tbView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tbView.reloadData()
        searchBar.endEditing(true)
    }
}
