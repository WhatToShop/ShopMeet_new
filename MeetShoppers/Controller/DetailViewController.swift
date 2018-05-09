//
//  DetailViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 5/7/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var checkinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check In", for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.sizeToFit()
        button.backgroundColor = UIColor.red
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("List", for: UIControlState.normal)
        button.layer.cornerRadius = 18
        button.sizeToFit()
        button.backgroundColor = UIColor.red
        return button
    }()
    
    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Chat", for: UIControlState.normal)
        button.layer.cornerRadius = 18
        button.sizeToFit()
        button.backgroundColor = UIColor.red
        return button
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Setting", for: UIControlState.normal)
        button.layer.cornerRadius = 18
        button.sizeToFit()
        button.backgroundColor = UIColor.red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(checkinButton)
//        view.addSubview(listButton)
//        view.addSubview(chatButton)
//        view.addSubview(settingButton)
        
        // Set up constraints of check in button
        checkinButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        checkinButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        checkinButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        checkinButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        // Set up caonstraints of list button
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
