//
//  Recherche.swift
//  SwiftProject
//
//  Created by m2sar on 10/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit
import Weather

class Recherche: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchDetail = segue.destination as? DetailsRecherche {
            searchDetail.query = cityName.text
        }
    }
}
