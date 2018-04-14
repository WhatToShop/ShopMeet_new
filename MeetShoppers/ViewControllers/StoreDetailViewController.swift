//
//  StoreDetailViewController.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import MapKit

class StoreDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let DEBUG = true
    // detailed view controller labels
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var checkInButtonView: UIButton!
    
    // individual cell view labels
    
    
    var stores: [String] = ["Kevin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DEBUG {
            print("Inside ViewDidLoad")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // set the labels as an oval
        checkInButtonView.layer.cornerRadius = checkInButtonView.frame.height / 2
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkInButton(_ sender: Any) {
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if DEBUG {
            print("Inside cellForRowAt")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DEBUG {
            print("Inside number Of Rows in section")
        }
        return stores.count
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
