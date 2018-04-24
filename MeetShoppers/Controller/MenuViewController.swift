//
//  MenuViewController.swift
//  MeetShoppers
//
//  Created by Bethany Bin on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let menuWidthFactor = 0.7

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var hideButton: UIButton!
    @IBAction func showMenu(_ sender: Any) {
        menuShow()
    }
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuHide()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitButton(_ sender: Any) {
        menuHide()
    }
    func menuShow(){
        UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                       animations: { () -> Void in
                        self.menuView.alpha = 1
                        self.profileImageView.alpha = 1
                        self.hideButton.alpha = 1
        }, completion: nil)
    }
    
    func menuHide(){
        UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                       animations: { () -> Void in
                        self.menuView.alpha = 0
                        self.profileImageView.alpha = 0
                        self.hideButton.alpha = 0
        }, completion: nil)
        
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
