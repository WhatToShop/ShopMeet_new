//
//  UsernameViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/26/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import Firebase

class UsernameViewController: UIViewController, UITextFieldDelegate {
    
    let enterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x2BC2C2)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.setTitle("Enter", for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleEnter), for: .touchUpInside)
        return button
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        usernameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add text field for getting username
        usernameTextField.delegate = self
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        // Add tap gesture recognizer to close text field when user tap on screen
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
        
        // Add enter button
        view.addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 100).isActive = true
        enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enterButton.widthAnchor.constraint(equalToConstant: 210).isActive = true
        enterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @objc func handleEnter() {
        guard let name = usernameTextField.text else { return }
        
        // Save username into Firebase
        let user = Auth.auth().currentUser!
        user.createProfileChangeRequest().displayName = name
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.child("displayName").setValue(name)
        performSegue(withIdentifier: "mainViewSegue", sender: nil)
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
