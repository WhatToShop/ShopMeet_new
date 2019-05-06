//
//  MessagePersonTableViewCell.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var interestLabel: UILabel?
    @IBOutlet weak var messagebtn: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Made it inside MessageCell.swift")
        
        profileView?.layer.cornerRadius = (profileView?.frame.height)!/2
        messagebtn?.layer.cornerRadius = (messagebtn?.frame.height)!/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func messageClicked(_ sender: Any) {
    }
    
}
