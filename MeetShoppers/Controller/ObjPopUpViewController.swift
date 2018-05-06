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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func saveMessageBtn(_ sender: Any) {
        let userID = Firebase.Auth.auth().currentUser!.uid
    ref?.child("users").child(userID).child("Notes").child(titleTextField.text).setValue(noteTextField.text)
        noteTextField.text = ""
        titleTextField.text = ""
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
