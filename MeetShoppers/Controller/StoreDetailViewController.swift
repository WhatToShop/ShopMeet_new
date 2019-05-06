//
//  StoreDetailViewController.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import MapKit


class StoreDetailViewController: UIViewController, BEMCheckBoxDelegate {
    //UITableViewDataSource, UITableViewDelegate

    let DEBUG = true
    // detailed view controller labels
    @IBOutlet weak var checkInStore: BEMCheckBox!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
   // @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storeImage: UIImageView!
    
    @IBOutlet weak var checkInButtonView: UIButton!
    @IBOutlet weak var myListbtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    
    var checkedIn: Bool = false
    
    var stores: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DEBUG {
            print("Inside ViewDidLoad")
        }
        checkInStore.on = false
        checkInStore.delegate = self
        
        /*checkInButtonView.layer.cornerRadius = checkInButtonView.frame.height / 2
        myListbtn.layer.cornerRadius = myListbtn.frame.height / 2
        mapBtn.layer.cornerRadius = mapBtn.frame.height / 2
        chatBtn.layer.cornerRadius = chatBtn.frame.height / 2
        */
        checkInButtonView.layer.borderColor = UIColor.black.cgColor
        myListbtn.layer.borderColor = UIColor.black.cgColor
        mapBtn.layer.borderColor = UIColor.black.cgColor
        chatBtn.layer.borderColor = UIColor.black.cgColor
        
        checkInButtonView.layer.borderWidth = 0.5
        myListbtn.layer.borderWidth = 0.5
        mapBtn.layer.borderWidth = 0.5
        chatBtn.layer.borderWidth = 0.5
        
        if let stores = stores {
            storeNameLabel.text = stores.name
            storeImage.af_setImage(withURL: stores.imageURL!)
            
        }
        storeImage.layer.cornerRadius = 20
        storeImage.clipsToBounds = true
        self.view.bringSubview(toFront: storeNameLabel);
        // Do any additional setup after loading the view.
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.tag == 1 && checkedIn == false {
            checkedIn = true
        } else {
            checkedIn = false
        }
    }
    
    @IBAction func checkInButton(_ sender: Any) {
       print("The user checked in")
    }
    
    @IBAction func mapBtn(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapPopUpId") as! MapPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
   
    @IBAction func chatButton(_ sender: Any) {
        if checkedIn {
            let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogViewController.business = stores
            navigationController?.pushViewController(chatLogViewController, animated: true)
        } else {
            print("Please check in first")
        }
    }
}
