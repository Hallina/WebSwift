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
    var isFav: Bool = false
    //var pageToGo: String?
    
    //variables temporaires
    var iconWeather: UIImage!
    var tmpTitle: String?
    var tmpDescription: String?
    var tmpTemp: Int = 0
    var tmpData: [String:Float] = [:]
    
    //variables
    var Key: [String] = []
    var Value: [Int] = []
    
    @IBOutlet weak var tableViewDetails: UITableView!
    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    @IBOutlet weak var StarButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        cityLabel.text = query!.name
        StarButton.isSelected = isFav
        
        let group = DispatchGroup()
        group.enter()
        
        weatherClient.weather(for: query!, completion: { (infoCity) in
            self.iconWeather = (infoCity?.weather[0].icon ?? nil)!
            self.tmpTitle = (infoCity?.weather[0].title ?? nil)!
            self.tmpDescription = (infoCity?.weather[0].description ?? nil)!
            
            self.tmpTemp = Int(roundf((infoCity?.temperature ?? nil)!))
            
            self.tmpData["Maximum"] = (infoCity?.temperatureMax ?? nil)!
            self.tmpData["Minimum"] = (infoCity?.temperatureMin ?? nil)!
            self.tmpData["Humidity"] = (infoCity?.humidity ?? nil)!
            self.tmpData["Clouds coverage"] = (infoCity?.cloudsCoverage ?? nil)!
            self.tmpData["Pressure"] = (infoCity?.pressure ?? nil)!
            self.tmpData["Wind speed"] = (infoCity?.windSpeed ?? nil)!
            self.tmpData["Wind orientation"] = (infoCity?.windOrientation ?? nil)!
            group.leave()
        })
        
        
        group.wait()
        //usleep(500000)
        
        for (key,value) in tmpData{
            Key.append(key)
            Value.append(Int(roundf(value)))
        }
        
        cityImageView.image = iconWeather
        weatherTitle.text = tmpTitle
        weatherDescription.text = tmpDescription
        temp.text = "\(tmpTemp)°C"
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? MoreDaysViewController {
            searchDetail.FavButton = self.StarButton
            searchDetail.query = self.query
            
            if (self.StarButton.isSelected == true) {
                searchDetail.isFav = true
            }
            else {
                searchDetail.isFav = false
            }
        }
    }
    
    @IBAction func moreClick(_ sender: Any) {
        performSegue(withIdentifier: "MoreDays", sender: self)
    }
    
    @IBAction func ClickBack(_ sender: Any) {
        
//        if pageToGo == "Search"{
//            tabBarController?.selectedIndex = 1
//        }
//        else{
//            tabBarController?.selectedIndex = 0
//        }
    }
    
    @IBAction func clickButton(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete it from your favorites?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Delete", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.StarButton.isSelected = false
            
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
