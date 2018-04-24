//
//  MenuCell.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/20/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = UIColor.white
        return label
    }()
    
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "chat")
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addContraintsWithFormat("H:|-16-[v0(30)]-16-[v1]|", views: iconImageView, nameLabel)
        addContraintsWithFormat("V:|[v0]|", views: nameLabel)
        addContraintsWithFormat("V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
