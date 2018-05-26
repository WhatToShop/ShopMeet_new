//
//  ReceiptsViewController.swift
//  MeetShoppers
//
//  Created by Bethany Bin on 5/7/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ReceiptsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var receiptsURL: [NSURL] = []
    var currReceipt : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width/cellsPerLine - interItemSpacingTotal/cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        loadReceipts()
    }

    func loadReceipts(){
        let userID  = (Auth.auth().currentUser?.uid)!
        let ref = Firebase.Database.database().reference().child("users/\(userID)/receipts")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get download URL from snapshot
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value
                let convertedURL = NSURL(string: value as! String)
                self.receiptsURL.append(convertedURL!)
                self.collectionView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receiptsURL.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
        let receipt = receiptsURL[indexPath.item]
        cell.receiptsImageView.af_setImage(withURL: receipt as URL)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell){
                let receipt = receiptsURL[indexPath.item]
                let vc = segue.destination as! DetailReceiptViewController
                if let data = try? Data(contentsOf: receipt as URL){
                   vc.imageSegue  = UIImage(data: data)
                }
        }
    }
   
    @IBAction func toEdit(_ sender: UIButton) {
        var currentTitle = sender.title(for: .normal)
        if(currentTitle == "Edit"){
            editButton.setTitle("Delete", for: .normal)
        }
        else{
            editButton.setTitle("Edit", for: .normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
