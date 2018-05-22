//
//  MainViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/13/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import FirebaseAuth
import Firebase

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, BusinessCellDelegate, UITextFieldDelegate {
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    let userID  = (Auth.auth().currentUser?.uid)!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var scrollCounter: Int = 0
    lazy var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    //var menuLauncher: SideMenu!
    //let menuView = SideMenu()
    var originalCellCenter: CGPoint!
    var businesses: [Business] = []
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D? {
        get {
            if let location = locationManager.location {
                return location.coordinate
            }
            return nil
        }
    }
    var api: YelpAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        api = YelpAPIClient(apiKey: "e9cKJ5oD_G0m9xYGjaViEdkcbSS8tauK9CucnRZqn6WuZFIJJu7WqRS-EoCkT_tECaQ4JcNUFQ4pHsLXnszUzL4uHyq5mchxi_wsVejAyH40E5ZD6d__bvsZzNfOWnYx")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.separatorStyle = .none
        refreshBusinesses(api: api)
       /* usernameTextField.delegate = self
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true*/
        
        //let edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanEdge))
        //edgePanRecognizer.edges = .left
        //view.addGestureRecognizer(edgePanRecognizer)
        
viewConstraint.constant = -150
        let ref  = Firebase.Database.database().reference().child("users/\(self.userID)/displayName")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let name = snapshot.value as! String
            self.screenNameLabel.text = name
            
        })
        
        //menuLauncher = SideMenu()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        menuView.alpha = 0
        self.blurEffectView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.cellForRow(at: indexPath) {
            return cell.frame.height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
  
    @IBAction func handleMenuPan(_ sender: UIPanGestureRecognizer) {
        menuView.alpha = 1
        if sender.state == .began || sender.state == .changed {
            
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {
                
                if viewConstraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.blurEffectView.frame = self.tableView.bounds
                        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.tableView.addSubview(self.blurEffectView)
                        self.tableView.isUserInteractionEnabled = false
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        
                    })
                }
                
            }else {
                if viewConstraint.constant > -150 {
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.tableView.isUserInteractionEnabled = true
                        self.viewConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        
                    })
                }
            }
            
            
        } else if sender.state == .ended {
            
            if viewConstraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.blurEffectView.removeFromSuperview()
                    self.tableView.isUserInteractionEnabled = true
                    self.viewConstraint.constant = -150
                    self.menuView.alpha = 0
                    self.view.layoutIfNeeded()
                    
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.tableView.isUserInteractionEnabled = false
                    self.viewConstraint.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
            }
            
        }
        
    }
    /* @objc func handlePanEdge(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        showMenu()
    }*/
    
    func businessCell(_ businessCell: UITableViewCell, didTapBusiness: Business) {
        performSegue(withIdentifier: "businessDetailSegue", sender: businessCell)
    }
    
    func showMenu(){
            UIView.animate(withDuration: 0.2, animations: {
                self.menuView.alpha = 1
                self.viewConstraint.constant = 0
                self.blurEffectView.frame = self.tableView.bounds
                self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.tableView.addSubview(self.blurEffectView)
                self.tableView.isUserInteractionEnabled = false
                self.menuView.layoutIfNeeded()
            })
            
        
        menuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.tableView.isUserInteractionEnabled = true
            self.menuView.alpha = 0
            self.blurEffectView.removeFromSuperview()
            self.viewConstraint.constant = -175
        }
    }
    
    @IBAction func toNotes(_ sender: Any) {
        performSegue(withIdentifier: "notesSegue", sender: nil)
    }
    
//    @IBAction func handleMap(_ sender: UIButton) {
//        performSegue(withIdentifier: "mapViewSegue", sender: nil)
//    }
    
    func refreshBusinesses(api: YelpAPIClient) {
        if api.isAuthenticated() {
            if let location = userLocation {
                api.searchBusinesses(latitude: location.latitude, longitude: location.longitude, radius: 40000, offset: scrollCounter*20, sortBy: "distance") { (json) in
                    self.businesses += Business.businesses(json: json)
                    self.tableView.reloadData()
                }
            } else {
                api.searchBusinesses(latitude: 22.3204, longitude: 114.1698, radius: 40000, offset: scrollCounter*20, sortBy: "distance") { (json) in
                    self.businesses += Business.businesses(json: json)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        let cell = tableView.cellForRow(at: indexPath)
//        performSegue(withIdentifier: "businessDetailSegue", sender: cell)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        cell.delegate = self 
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Implements infinte scrolling
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == businesses.count - 1 {
            scrollCounter += 1
            refreshBusinesses(api: api!)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "receiptsSegue":
            let vc = segue.destination as! ReceiptsViewController
            break
        case "notesSegue":
            let vc = segue.destination as! ToDoViewController
            break
        case "detailViewSegue":
            print("reached detailView")
            let vc = segue.destination as! StoreDetailViewController
            break
        case "mapViewSegue":
            let vc = segue.destination as! MapViewController
            vc.businesses = self.businesses
        case "detailSegue":
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let store = businesses[indexPath.row]
                let detailViewController = segue.destination as! StoreDetailViewController
                detailViewController.stores = store
            }
        case "businessDetailSegue":
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let business = businesses[indexPath.row]
                api.getBusinessInfo(id: business.id!) { (json) in
                    let detailedBusiness = DetailedBusiness(dictionary: json)
                    let vc = segue.destination as! BusinessDetailViewController
                    vc.business = detailedBusiness
                }
            }
        case "changeNameSegue":
            let vc = segue.destination as! ChangeNameViewController
        default:
            break
        }
    }
    
    @IBAction func onMenu(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func onMap(_ sender: UIButton) {
        performSegue(withIdentifier: "mapViewSegue", sender: nil)
    }
    
//    @IBAction func handleMenu(_ sender: Any) {
//        showMenu()
//    }
    
    @IBAction func logOut(_ sender: Any) {
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
    
    
    @IBAction func showReceipts(_ sender: Any) {
        performSegue(withIdentifier: "receiptsSegue", sender: nil)
    }
    
    @IBAction func showNotes(_ sender: Any) {
    }
    
    @IBAction func showCamera(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showBookmarks(_ sender: Any) {
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
       
        if let selectedImage = selectedImageFromPicker{
            let userID : String = (Auth.auth().currentUser?.uid)!
            let uuid = UUID().uuidString
            let receiptName : String = uuid + ".jpg"
            let receiptsKey = "users/\(userID)/receipts/\(receiptName)"
            let storageRef = Storage.storage().reference(withPath: receiptsKey)
            let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            let ref = Firebase.Database.database().reference().child("users/\(userID)/receipts")

            if let uploadData = UIImagePNGRepresentation(selectedImage){
                storageRef.putData(uploadData, metadata: uploadMetadata, completion: { (metadata, error) in
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            debugPrint(error)
                            let alert = UIAlertController(title: "Receipt Unable to Uploaded", message: "Please Try Again", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "Continue", style: .default) { _ in
                                // do nothing
                            }
                            alert.addAction(okayAction)
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else if let urlString = url?.absoluteString{
                            let alert = UIAlertController(title: "Receipt Uploaded", message: "Look at your receipts in the receipts section of the menu", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "Continue", style: .default) { _ in
                                // do nothing
                            }
                            alert.addAction(okayAction)
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                             ref.child(uuid).setValue(urlString)
                        }
                    })
                })

            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
 
   
    
}
    
    
    

