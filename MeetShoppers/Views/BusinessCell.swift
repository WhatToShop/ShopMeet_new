//
//  BusinessCell.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import AlamofireImage

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    
    var business: Business! {
        didSet {
            if let url = business.imageURL {
                businessImageView.af_setImage(withURL: url)
            }
            
            if let name = business.name {
                nameLabel.text = name
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        businessImageView.layer.cornerRadius = 20
        businessImageView.clipsToBounds = true
        
        nameLabel.sizeToFit()
        nameLabel.backgroundColor = UIColor(rgb: 0xFFFFFF)
        nameLabel.textColor = UIColor(rgb: 0xD43D3D)
        nameLabel.layer.cornerRadius = 8
        nameLabel.clipsToBounds = true
        nameLabel.textAlignment = .center
        
        self.layer.borderWidth = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
