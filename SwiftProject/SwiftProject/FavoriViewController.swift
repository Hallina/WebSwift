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
    let weatherClient = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9")
    var activeCity: City?
    @IBOutlet weak var myTableView: UITableView!
    var listFav: [City] = []
    let defaults = UserDefaults.standard
    var imageWeather: UIImage?
    var tmpTemp: Float = 0.0
    var temperature: Int = 0
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loaded()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? DetailsViewController {
            searchDetail.listFav = self.listFav
            searchDetail.query = self.activeCity
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loaded()
        return listFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell") as! FavCell
        loaded()
        let favoris = listFav[indexPath.row]
    
        let group = DispatchGroup()
        group.enter()
        weatherClient.weather(for: favoris, completion: { (infoCity) in
            self.imageWeather = infoCity?.weather[0].icon ?? nil
            self.tmpTemp = (infoCity?.temperature ?? nil)!
            group.leave()
        })
        group.wait()
        cell.cityFav.text = favoris.name
        cell.countryFav.text = favoris.country
        cell.imageWeather.image = imageWeather
        temperature = Int(roundf(tmpTemp))
        cell.tempFav.text = "\(temperature)°C"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        activeCity = listFav[index]
        performSegue(withIdentifier: "cityWeatherFromFav", sender: self)
    }
}

class FavCell: UITableViewCell {
    @IBOutlet weak var cityFav: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var tempFav: UILabel!
    @IBOutlet weak var countryFav: UILabel!
    
}
