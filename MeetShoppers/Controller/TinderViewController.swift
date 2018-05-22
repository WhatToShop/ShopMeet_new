//
//  TinderViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 5/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase



struct IndividualUser{
    var name: String?
    var UID: String?
    var ProfileURL: URL?
}

class TinderViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    var ref: DatabaseReference?
    var cardInitialCenter: CGPoint!
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        print("made it inside didPan")
        
    }
    
    override func viewDidLoad() {
        print("Made into Tinder viewDidLoad")
        let userID = Firebase.Auth.auth().currentUser!.uid
        ref = Database.database().reference()
        ref?.child("users").observe(.childAdded, with: {snapShot in
                print(snapShot)
                if snapShot != nil {
                    for child in snapShot.children {
                        print(child)
                    }
                }
            }// checking condition to make sure there are no duplicates
        )
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing( true )
    }
    
}
    

