//
//  IndividualNoteViewController.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 5/7/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class IndividualNoteViewController: UIViewController {

    @IBOutlet weak var DetailTextLabel: UITextView!
    
    var singleNote: note?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let singleNote = singleNote {
            DetailTextLabel.text = singleNote.message
            self.title = singleNote.title
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
