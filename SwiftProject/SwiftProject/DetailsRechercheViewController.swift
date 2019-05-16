//
//  DetailsRecherche.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class DetailsRechercheViewController: UIViewController {
    
    var query: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let citys = WeatherClient(key: "9e6d39413722f1a451125d937bf8b5b9").citiesSuggestions(for: query ?? "")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}
