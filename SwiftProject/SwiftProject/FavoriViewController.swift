//
//  Favori.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class FavoriViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    var listFav: [City] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loaded()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell") as! FavCell
        
        if listFav != nil {
            for city in listFav{
                cell.cityFav.text = city.name
                cell.countryFav.text = city.country
                cell.imageWeather.image = city.weather[0].icon ?? nil
            }
        }
        return cell
    }
}

class FavCell: UITableViewCell {
    @IBOutlet weak var cityFav: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var tempFav: UILabel!
    @IBOutlet weak var countryFav: UILabel!
    
}
