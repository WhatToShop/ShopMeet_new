//
//  MapViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/22/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    var locationManager: CLLocationManager!
    var userRegion: MKCoordinateRegion?
    let mapSpan: MKCoordinateSpan = {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        return span
    }()
    
    func createShopPin(business: Business) {
        guard let latitude = business.latitude, let longitude = business.longitude else { return }
        
        var pin = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        pin.coordinate = coordinate
        pin.title = business.name!
        mapView.addAnnotation(pin)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if let userLocation = locationManager.location {
            mapView.showsUserLocation = true
            userRegion = MKCoordinateRegion(center: userLocation.coordinate, span: mapSpan)
            mapView.setRegion(userRegion!, animated: false)
        }
        
        // Add shop pins to the map view 
        for business in businesses {
            createShopPin(business: business)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        performSegue(withIdentifier: "mainViewSegue", sender: nil)
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
