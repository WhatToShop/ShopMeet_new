//
//  BottomBorderedTextField.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/6/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class BottomBorderedTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    func setupBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        border.opacity = 0.5
        
        self.layer.addSublayer(border)
        self.borderStyle = UITextBorderStyle.none
        self.layer.masksToBounds = true
    }
}
