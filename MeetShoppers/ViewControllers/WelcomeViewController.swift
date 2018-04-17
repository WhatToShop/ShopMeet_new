//
//  ViewController.swift
//  ShopMeet
//
//  Created by Kelvin Lui on 4/5/18.

import UIKit

class WelcomeViewController: UIViewController {
  
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        signinButton.backgroundColor = UIColor(rgb: 0x2BC2C2)
        signinButton.layer.cornerRadius = 22
        signinButton.clipsToBounds = true
        
        // testing API
        let client = YelpAPIClient(apiKey: "e9cKJ5oD_G0m9xYGjaViEdkcbSS8tauK9CucnRZqn6WuZFIJJu7WqRS-EoCkT_tECaQ4JcNUFQ4pHsLXnszUzL4uHyq5mchxi_wsVejAyH40E5ZD6d__bvsZzNfOWnYx")
        if client.isAuthenticated() {
            client.searchBusinesses(latitude: 32.715736, longitude: -117.161087, radius: 40000) { (json) in
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignin(_ sender: UIButton) {
        performSegue(withIdentifier: "signinSegue", sender: nil)
    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        performSegue(withIdentifier: "signupSegue", sender: nil)
    }
}

