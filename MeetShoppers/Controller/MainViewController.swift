//
//  MainViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/13/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuLauncher: SideMenu!
    var originalCellCenter: CGPoint!
    var businesses: [Business]!
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D? {
        get {
            if let location = locationManager.location {
                return location.coordinate
            }
            return nil
        }
    }
    var api: YelpAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        api = YelpAPIClient(apiKey: "e9cKJ5oD_G0m9xYGjaViEdkcbSS8tauK9CucnRZqn6WuZFIJJu7WqRS-EoCkT_tECaQ4JcNUFQ4pHsLXnszUzL4uHyq5mchxi_wsVejAyH40E5ZD6d__bvsZzNfOWnYx")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240
        tableView.separatorStyle = .none
        refreshBusinesses(api: api)
        
        let edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanEdge))
        edgePanRecognizer.edges = .left
        view.addGestureRecognizer(edgePanRecognizer)
        
        menuLauncher = SideMenu()
    }
    
    @objc func handlePanEdge(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .ended {
            menuLauncher.showMenu()
        }
    }
    
    func refreshBusinesses(api: YelpAPIClient) {
        if api.isAuthenticated() {
            api.searchBusinesses(latitude: userLocation?.latitude, longitude: userLocation?.longitude, radius: 40000) { (json) in
                self.businesses = Business.businesses(json: json)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "detailViewSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        print("longitude: \(cell.business.longitude!), latitude: \(cell.business.latitude!)")
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "detailViewSegue":
            let vc = segue.destination as! StoreDetailViewController
            break
        default:
            break
        }
     }
}
