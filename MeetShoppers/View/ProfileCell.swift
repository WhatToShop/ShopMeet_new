//
//  ProfileCell.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/20/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tim Cook"
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(usernameLabel)
        addContraintsWithFormat("H:|-16-[v0]|", views: usernameLabel)
        addContraintsWithFormat("V:|[v0]|", views: usernameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
