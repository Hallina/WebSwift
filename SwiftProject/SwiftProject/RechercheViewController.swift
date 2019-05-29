//
//  Recherche.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class RechercheViewController: UIViewController {
    
    //@IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityName: UITextField!
    
    @IBAction func back(_ sender: Any) {
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbView: UITableView!
    
    //var page: String = "Search"
    var cities: [City]!
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
        
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? DetailsViewController {
            searchDetail.query = self.activeCity
            //searchDetail.pageToGo = self.page
        }
    }
}

extension RechercheViewController: UITableViewDataSource, UITableViewDelegate{
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

extension RechercheViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // clean datas
        citiesName.removeAll()
        citiesID.removeAll()
        citiesCountry.removeAll()
        
        // search from the text entered
        searchCities(searchText: searchBar.text!)
        
        // prepare for table view
        for city in cities {
            citiesName.append(city.name)
            citiesID.append(city.identifier)
            citiesCountry.append(city.country)
        }
        
        searching = true
        tbView.reloadData() // reload the tableview
    }
    
    func searchCities (searchText: String) {
        cities = nil
        if (searchText != ""){
            cities = weatherClient.citiesSuggestions(for: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tbView.reloadData()
        searchBar.endEditing(true)
    }
}
