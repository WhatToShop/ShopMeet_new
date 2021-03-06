//
//  BusinessCell.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase
import SwiftyJSON

protocol BusinessCellDelegate: NSObjectProtocol {
    func businessCell(_ businessCell: UITableViewCell, didTapBusiness: Business)
}

class BusinessCell: UITableViewCell {
    let cellId = "cellId"
    var delegate: BusinessCellDelegate!
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleBookmark), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "bookmark_inactive"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "bookmark_active"), for: UIControlState.selected)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleChat), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "chat"), for: UIControlState.normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleLike), for: UIControlEvents.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "like_inactive"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "like_active"), for: UIControlState.selected)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.textColor = UIColor(rgb: 0xD43D3D)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    lazy var businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var business: Business! {
        didSet {
            if let likeCount = business.likeCount { likeCountLabel.text = String(likeCount) + (likeCount > 1 ? " likes" : " like") }
            if let url = business.imageURL { businessImageView.af_setImage(withURL: url) }
            if let name = business.name { nameLabel.text = name }
            if let distance = business.distance { distanceLabel.text = distance }
        }
    }
    
    @objc func handleBookmark() {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
    
    @objc func handleStar() {
        // TODO
        
        
    }
    
    @objc func handleTap() {
        delegate.businessCell(self, didTapBusiness: business)
    }
    
    @objc func handleLike() {
        let didUserLike = !likeButton.isSelected
        likeButton.isSelected = didUserLike
        business.likeCount! += (didUserLike ? 1 : -1)
        likeCountLabel.text = "\(business.likeCount!) " + (business.likeCount! > 1 ? "likes" : "like")
        
        // Add uid to database to specify the user has liked the busienss
        
    }
    
    @objc func handleChat() {
        // TODO
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        // Add name label to the cell
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.width - 32)*0.8).isActive = true
        
        // Add distance label
        contentView.addSubview(distanceLabel)
        distanceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        distanceLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        
        // Add image view to the cell
        contentView.addSubview(businessImageView)
        businessImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16).isActive = true
        businessImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        businessImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        businessImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        // Add like button under business image view
        contentView.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 8).isActive = true
        likeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add chat button under business image view on the right of like button
        contentView.addSubview(chatButton)
        chatButton.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 8).isActive = true
        chatButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 16).isActive = true
        chatButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add star button on the right edge under business image view
        contentView.addSubview(bookmarkButton)
        bookmarkButton.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 8).isActive = true
        bookmarkButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add like count label under fav/chat buttons
        contentView.addSubview(likeCountLabel)
        likeCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8).isActive = true
        likeCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        likeCountLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40).isActive = true
        likeCountLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
}
