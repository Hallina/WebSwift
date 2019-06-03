//
//  MoreDaysViewController.swift
//  SwiftProject
//
//  Created by m2sar on 29/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class MoreDaysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var FavButton: UIButton!
    let weatherClient = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9")
    var query: City?
    var listFav: [City] = []
    var isFav: Bool?
    var prevision: [Forecast]!
    var calendar = Calendar.current
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var myTB: UITableView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    var iconWeather: UIImage!
    var tmpTemp: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cityLabel.text = query!.name
        FavButton.isSelected = isFav!
        
        let group = DispatchGroup()
        group.enter()
        
        weatherClient.weather(for: query!, completion: { (infoCity) in
            self.iconWeather = (infoCity?.weather[0].icon ?? nil)!
            
            self.tmpTemp = Int(roundf((infoCity?.temperature ?? nil)!))
            
            group.leave()
            
        })
        group.wait()
        
        weatherClient.forecast(for: query!) { (prevision) in
            self.prevision = prevision!
        }
        
        cityImageView.image = iconWeather
        temp.text = "\(tmpTemp)°C"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? DetailsViewController {
            searchDetail.query = self.query
            searchDetail.listFav = self.listFav
            
            if (self.FavButton.isSelected == true) {
                searchDetail.isFav = true
            }
            else {
                searchDetail.isFav = false
            }
        }
    }
    
    func save(listFav: [City]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(listFav) {
            defaults.set(encoded, forKey: "SavedFav")
        }
    }

    @IBAction func clickBack(_ sender: Any) {
        performSegue(withIdentifier: "BackDetails", sender: self)
    }
    
    @IBAction func ClickButton(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete it from your favorites?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Delete", style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.FavButton.isSelected = false
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
        
        if FavButton.isSelected == true{
            alert.addAction(clearAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion:nil)
        }
        else {
            FavButton.isSelected = true
            listFav.append(query!)
            save(listFav: listFav)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherClient.forecast(for: query!) { (prevision) in
            self.prevision = prevision!
        }
        usleep(500000)
        return prevision.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTB.dequeueReusableCell(withIdentifier: "cell") as! MoreDaysCell
        
        if prevision != nil {
            cell.day.text = (prevision[indexPath.row].date).dayOfWeek()
            let tmp : String = (prevision[indexPath.row].date).hourOfWeek()!
            cell.hour.text = "\(tmp)h"
            
            cell.imageWeather.image = prevision[indexPath.row].weather[0].icon ?? nil
            let temp = Int(roundf(prevision[indexPath.row].temperature))
            cell.degree.text = "\(temp)°C"
        }
        return cell
    }

}

class MoreDaysCell : UITableViewCell{
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var degree: UILabel!
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func hourOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
