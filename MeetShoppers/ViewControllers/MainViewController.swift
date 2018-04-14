//
//  MainViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/13/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            let coordiante = location.coordinate
            let label = UILabel()
            label.text = "Longitude: \(coordiante.longitude), latitude: \(coordiante.latitude)"
            label.center = self.view.center
            label.isHidden = false 
            self.view.addSubview(label)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
