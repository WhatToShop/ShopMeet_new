//
//  MenuCell.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/20/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.gray : UIColor(rgb: 0xD43D3D)
        }
    }
    
    let optionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Option", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.selected)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(handleOption), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    @objc func handleOption() {
        optionButton.isSelected = !optionButton.isSelected
    }
    
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "chat")
        iconImageView.contentMode = .scaleAspectFit
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(optionButton)
        addSubview(iconImageView)
        
        addContraintsWithFormat("H:|-16-[v0(30)]-16-[v1]|", views: iconImageView, optionButton)
        addContraintsWithFormat("V:|[v0]|", views: optionButton)
        addContraintsWithFormat("V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
