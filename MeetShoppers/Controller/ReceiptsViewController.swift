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
    var toDeleteURL: [String] = []
    var currReceipt : UIImage!
    var editBool: Bool!
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
        editBool = false
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
                let key = snap.key
                let convertedURL = NSURL(string: value as! String)
                self.receiptsURL.append(convertedURL!)
                self.toDeleteURL.append(key)
                //add something to deleteURL
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
        cell.link = receipt as URL!
        cell.ID = toDeleteURL[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath)  as! ReceiptCell
        if(editBool){
            var itemToRemove = cell.ID
            if let index = toDeleteURL.index(of: itemToRemove!) {
                toDeleteURL.remove(at: index)
            }
            var itemToRemove2 = cell.link
            if let index = receiptsURL.index(of: itemToRemove2 as! NSURL) {
                receiptsURL.remove(at: index)
            }

            let userID  = (Auth.auth().currentUser?.uid)!
            FirebaseDatabase.Database.database().reference(withPath: "users/\(userID)/receipts").child(cell.ID).removeValue()
        }
         self.collectionView.reloadData()
        
    }
   /* func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print("coming into did select item at")
        let receipt = receiptsURL[indexPath.item]
        if let data = try? Data(contentsOf: receipt as URL){
            currReceipt = UIImage(data: data)
            print(currReceipt)
        }
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }*/
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !editBool
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        if(currentTitle == "Delete"){
            editButton.setTitle("Done", for: .normal)
            editBool = true
            let alert = UIAlertController(title: "Delete Receipts", message: "click on photo(s) to delete", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Continue", style: .default) { _ in
                // do nothing
            }
            alert.addAction(okayAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            editButton.setTitle("Delete", for: .normal)
            editBool = false
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
