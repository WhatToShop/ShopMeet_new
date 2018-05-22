//
//  ObjPopUpViewController.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ObjPopUpViewController: UIViewController {

    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextView!
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func saveMessageBtn(_ sender: Any) {
        print("Save message btn")
        let userID = Firebase.Auth.auth().currentUser!.uid
        ref?.child("users").child(userID).child("Notes").child(titleTextField.text).setValue(noteTextField.text)
        noteTextField.text = ""
        titleTextField.text = ""
    }
}
