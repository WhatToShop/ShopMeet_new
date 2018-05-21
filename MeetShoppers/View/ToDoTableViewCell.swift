//
//  ToDoTableViewCell.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 4/30/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    //@IBOutlet weak var titleLabel: UILabel!
   // var note: note?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Temp text"
        return label
    }()
    
    lazy var rightSignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ">"
        return label
    }()
    
    var Note: note! {
        didSet {
            if let title = Note?.title {
                //print("Title", title)
                titleLabel.text = title
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // print("MADE IT INSIDE TODO TABLE VIEW CELL")
       
        //formatting the title
        setupLayout()
      //  print("After awakefromNib")
        // Initialization code
    }
    
    func setupLayout() {
         contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        //titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        
        contentView.addSubview(rightSignLabel)
        rightSignLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 30).isActive = true
        rightSignLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        rightSignLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 300).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
