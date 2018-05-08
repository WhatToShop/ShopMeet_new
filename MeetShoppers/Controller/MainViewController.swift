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
UINavigationControllerDelegate{

   
    
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var scrollCounter: Int = 0
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
        
        let edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanEdge))
        edgePanRecognizer.edges = .left
        view.addGestureRecognizer(edgePanRecognizer)
        
//        viewConstraint.constant = -175
        
        //menuLauncher = SideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menuView.alpha = 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.cellForRow(at: indexPath) {
            return cell.frame.height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    @objc func handlePanEdge(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        showMenu()

    }
    
    func showMenu(){
        
            UIView.animate(withDuration: 0.2, animations: {
                self.menuView.alpha = 1
                self.viewConstraint.constant = 0
                self.menuView.layoutIfNeeded()
            })
            
        
        menuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.menuView.alpha = 0
            self.viewConstraint.constant = -175
        }
    }
    
    @IBAction func toNotes(_ sender: Any) {
        performSegue(withIdentifier: "notesSegue", sender: nil)
    }
    @IBAction func handleMap(_ sender: UIButton) {
        performSegue(withIdentifier: "mapViewSegue", sender: nil)
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogViewController.business = businesses[indexPath.row]
        navigationController?.pushViewController(chatLogViewController, animated: true)
    }
    
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
        /*case "cameraViewSegue":
            print("reached cameraViewSegue")
            let vc = segue.destination as! CameraViewController
            break*/
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
        default:
            break
        }
    }
    
    @IBAction func handleMenu(_ sender: Any) {
        showMenu()
    }
    
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
    }
    
    @IBAction func showNotes(_ sender: Any) {
    }
    
    @IBAction func showCamera(_ sender: Any) {
        print("camera view controller view did load")
        
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
    
    
    

