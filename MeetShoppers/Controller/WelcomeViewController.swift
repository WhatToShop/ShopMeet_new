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

