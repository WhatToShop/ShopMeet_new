//
//  ChangeNameViewController.swift
//  MeetShoppers
//
//  Created by Bethany Bin on 5/20/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChangeNameViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var changeNameTextView: UITextView!
    let userID  = (Auth.auth().currentUser?.uid)!
    override func viewDidLoad() {
        super.viewDidLoad()

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target:nil, action: nil)
        //let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneClicked))
        //toolBar.setItems([flexibleSpace, doneButton], animated: false)
        //changeNameTextView.inputAccessoryView = UIView()
        
        changeNameTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneClicked))
        self.view.addGestureRecognizer(tapGesture)
        
       changeNameTextView.text = "Enter your screen name"
       changeNameTextView.textColor = UIColor.lightGray
        
        
        


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(changeNameTextView.text != "Enter your screen name"){
            let ref  = Firebase.Database.database().reference().child("users/\(self.userID)/displayName")
            ref.setValue(changeNameTextView.text)
            print(changeNameTextView.text)
        }
    }
    
    func textViewDidBeginEditing(_ changeNameTextView: UITextView) {
        if changeNameTextView.textColor == UIColor.lightGray {
            changeNameTextView.text = nil
            changeNameTextView.textColor = UIColor.black
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidChange(changeNameTextView: UITextView) {
        print("i dont think its coming in here")
        print(changeNameTextView.text)
    }
    
    
    @objc func doneClicked(){
        changeNameTextView.endEditing(true)
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
