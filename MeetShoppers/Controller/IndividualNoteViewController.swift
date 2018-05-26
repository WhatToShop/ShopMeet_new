//
//  IndividualNoteViewController.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 5/7/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class IndividualNoteViewController: UIViewController {

    @IBOutlet weak var textLabel: UITextView!
    var singleNote: note?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let singleNote = singleNote {
            self.textLabel.text = singleNote.message
            self.title = singleNote.title
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("View did disappear")
        let userID = Firebase.Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        print(singleNote?.title)
        print(textLabel.text)
        ref.child("users").child(userID).child("Notes").child((singleNote?.title)!).setValue(textLabel.text)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
