//
//  MenuLauncher.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/20/18.
//

import UIKit

class SideMenu : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(rgb: 0xD43D3D)
        return cv
    }()
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            let collectionViewWidth = window.frame.width * 0.7
            collectionView.frame = CGRect(x: -collectionViewWidth, y: 0, width: collectionViewWidth, height: window.frame.height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        handleDismiss()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: -self.collectionView.frame.width, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!
        switch indexPath.section {
        case 0:
            size = CGSize(width: collectionView.frame.width, height: 200)
        default:
            size = CGSize(width: collectionView.frame.width, height: 50)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        switch indexPath.section {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath)
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath)
        }
        return cell
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: "optionCell")
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "profileCell")
    }
}
