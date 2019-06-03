//
//  DetailsFav.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.


import UIKit
import Weather

class DetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    let weatherClient = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9")
    var query: City?
    var listFav: [City] = []
    var isFav: Bool = false
    //var pageToGo: String?
    
    //variables temporaires
    var iconWeather: UIImage!
    var tmpTitle: String?
    var tmpDescription: String?
    var tmpTemp: Float = 0.0
    var temperature: Int = 0
    var tmpData: [String:Float] = [:]
    
    //variables
    var Key: [String] = []
    var Value: [Float] = []
    
    @IBOutlet weak var tableViewDetails: UITableView!
    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    @IBOutlet weak var StarButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setElem()
        
        
    }
    
    func setElem(){
        cityLabel.text = query!.name
        if listFav.count != 0{
            for elem in listFav {
                if elem.identifier == query?.identifier {
                    isFav = true
                }
            }
        }
        StarButton.isSelected = isFav
        
        let group = DispatchGroup()
        group.enter()
        
            weatherClient.weather(for: query!, completion: { (infoCity) in
                self.iconWeather = (infoCity?.weather[0].icon)!
                self.tmpTitle = (infoCity?.weather[0].title)!
                self.tmpDescription = (infoCity?.weather[0].description)!
                
                self.tmpTemp = (infoCity?.temperature)!
                
                self.tmpData["Maximum"] = (infoCity?.temperatureMax ?? 0.0)!
                self.tmpData["Minimum"] = (infoCity?.temperatureMin ?? 0.0)!
                self.tmpData["Humidity"] = (infoCity?.humidity ?? 0.0)!
                self.tmpData["Clouds coverage"] = (infoCity?.cloudsCoverage ?? 0.0)!
                self.tmpData["Pressure"] = (infoCity?.pressure ?? 0.0)!
                self.tmpData["Wind speed"] = (infoCity?.windSpeed ?? 0.0)!
                self.tmpData["Wind orientation"] = (infoCity?.windOrientation ?? 0.0)!
                group.leave()
            })
        
        group.wait()
        //usleep(500000)
        for (key,value) in tmpData{
            Key.append(key)
            Value.append(value)
        }
        
        cityImageView.image = iconWeather
        weatherTitle.text = tmpTitle
        weatherDescription.text = tmpDescription
        
        temperature = Int(roundf(tmpTemp))
        temp.text = "\(temperature)°C"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? MoreDaysViewController {
            searchDetail.FavButton = self.StarButton
            searchDetail.query = self.query
            searchDetail.listFav = self.listFav
            
            if (self.StarButton.isSelected == true) {
                searchDetail.isFav = true
            }
            else {
                searchDetail.isFav = false
            }
        }else{
            
        }
    }
    
    func save(listFav: [City]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(listFav) {
            defaults.set(encoded, forKey: "SavedFav")
        }
    }
    
    @IBAction func moreClick(_ sender: Any) {
        performSegue(withIdentifier: "MoreDays", sender: self)
    }
    
    @IBAction func clickButton(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete it from your favorites?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Delete", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.StarButton.isSelected = false
            var index: Int = 0
            for elem in self.listFav{
                if elem.identifier != self.query?.identifier {
                    index += 1
                }
            }
            self.listFav.remove(at: index)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            
        }
        
        if StarButton.isSelected == true{
            alert.addAction(clearAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion:nil)
        }
        else {
            StarButton.isSelected = true
            listFav.append(query!)
            save(listFav: listFav)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpData.count
    }
    
    // number of section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = Key[indexPath.row]
        cell?.detailTextLabel?.text = String(Value[indexPath.row])
        
        return cell!
    }
}
