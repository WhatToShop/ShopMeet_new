//
//  MenuLauncher.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/20/18.
//

import UIKit
import FirebaseAuth

class SideMenu : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate{
    var mainVC = MainViewController()
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
            
            let signOutButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            signOutButton.backgroundColor = nil
            signOutButton.setTitle("Logout", for: .normal)
            signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
            
            window.addSubview(signOutButton)
            
            let scanButton = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
            scanButton.backgroundColor = nil
            scanButton.setTitle("Scan", for: .normal)
            scanButton.addTarget(self, action: #selector(scan), for: .touchUpInside)
            
            window.addSubview(scanButton)
        }
    }
    
    @objc func scan(sender: UIButton!) {
        print("button being pressed")
        let cameraViewController = CameraViewController()
        //let storyboard = UIStoryboard(name: "Main", bundle: nil);
        //mainVC.navigationController?.pushViewController(cameraViewController, animated: true)
        //let vc = storyboard.instantiateViewController(withIdentifier: "cameraViewController")
        //mainVC?.present(vc, animated: true, completion: nil);
        let mainViewController = MainViewController()
        //mainViewController.prepare(for: UIStoryboardSegue, sender: mainViewController)
        //mainViewController.performSegue(withIdentifier: "cameraViewSegue", sender: mainViewController)
        mainViewController.present(cameraViewController, animated: false, completion: nil)
        
    }
    
    func showNextView(mainViewController: MainViewController){
        mainViewController.testScan()
    }

    
    @objc func signOut(sender: UIButton!) {
        do
        {
            let window = UIApplication.shared.keyWindow
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "welcomeVC")
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
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



