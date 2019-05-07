//
//  ViewController.swift
//  SwiftProject
//
//  Created by m2sar on 07/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paris = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9").citiesSuggestions(for: "Paris")
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

