//
//  DetailsFav.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.


import UIKit
import Weather

class DetailsViewController: UIViewController {
    let weatherClient = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9")
    var query: City?
    
    var iconWeather: UIImage!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    
    @IBOutlet weak var StarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        cityLabel.text = query!.name
        weatherClient.weather(for: query!, completion: { (infoCity) in
            self.iconWeather = (infoCity?.weather[0].icon ?? nil)!
        })
        
        cityImageView.image = iconWeather
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
    
}
