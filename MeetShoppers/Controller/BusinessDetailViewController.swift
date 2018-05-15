//
//  BusinessDetailViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 5/11/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//
import UIKit
import Firebase
import CoreLocation

class BusinessDetailViewController: UIViewController, CLLocationManagerDelegate {
    
    let greyLineDividerHeight: CGFloat = 8
    var locationManager: CLLocationManager?
    var userCoordinate: CLLocationCoordinate2D?
    var isUserCheckedIn: Bool?
    var checkInsRefs: DatabaseReference?
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "more-button-interface-symbol-of-three-horizontal-aligned-dots"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMenu), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "bookmark_inactive_red"), for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "bookmark_active"), for: UIControlState.selected)
        button.addTarget(self, action: #selector(handleBookmark), for: UIControlEvents.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left-arrow"), for: UIControlState.normal)
        button.setTitle("Nearby", for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(handleBack), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var business: DetailedBusiness! {
        didSet {
            checkInsRefs = Firebase.Database.database().reference().child("businesses").child(business.id!).child("checkIns")
            
            businessImageView.af_setImage(withURL: business.imageURL!)
            businessTitleLabel.text = business.name!
            var businessCategoryString = ""
            for i in 0..<business.categories.count {
                businessCategoryString.append(business.categories[i])
                businessCategoryString.append(i == business.categories.count - 1 ? "" : ", ")
            }
            businessTypeLabel.text = businessCategoryString
            
            if business.isOpenNow! {
                statusLabel.text = "Open"
                statusLabel.textColor = UIColor(rgb: 0x41a700)
            } else {
                statusLabel.text = "Closed"
                statusLabel.textColor = UIColor(rgb: 0xd32d2d)
            }
            
            let dayIndex = Date().dayNumberOfWeek()
            if business.isOpenNow! {
                if dayIndex > business.endTimes!.count {
                    hourLabel.text = "on \(Date().weekdayName(weekday: dayIndex))"
                }
                hourLabel.text = "until \(business.endTimes![dayIndex])"
            } else {
                hourLabel.text = "\(business.startTimes![dayIndex]) - \(business.endTimes![dayIndex])"
            }
        }
    }
    
    let greyLineDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(rgb: 0xe8e8e8)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        return divider
    }()
    
    let businessTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        //        label.font = UIFont.systemFont(ofSize: 20)
        //        label.font = UIFont.boldSystemFont(ofSize: 20)
        //        label.textColor = UIColor(rgb: 0xd43d3d)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let businessTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func handleBookmark() {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
    
    private func handleCheckout() {
        let uid = Firebase.Auth.auth().currentUser!.uid
        checkInsRefs?.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                self.checkInsRefs?.child(uid).removeValue()
                self.isUserCheckedIn = false
            }
        })
    }
    
    private func handleCheckin() {
        // Implement check-in feature with access to database
        let userLocation = CLLocation(latitude: userCoordinate!.latitude, longitude: userCoordinate!.longitude)
        let businessLocation = CLLocation(latitude: business.coordinate!.latitude, longitude: business.coordinate!.longitude)
        
        if userLocation.distance(from: businessLocation) > 600 {
            let alert = UIAlertController(title: "Too Far Away", message: "You are too far away from \(business.name!). Get closer before you check in.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        } else {
            let alert = UIAlertController(title: "Greeting", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField { (textfield) in
                textfield.placeholder = "Enter your greeting message here..."
            }
            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { (action) in
                self.isUserCheckedIn = true
                let uid = Firebase.Auth.auth().currentUser!.uid
                self.checkInsRefs!.child(uid).setValue(alert.textFields![0].text!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleChat() {
        let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        guard let business = self.business else {
            debugPrint("Failed to downcast DetailedBusiness into Business.")
            return
        }
        chatLogViewController.business = business
        navigationController?.pushViewController(chatLogViewController, animated: true)
    }
    
    private func handleNotes() {
        self.performSegue(withIdentifier: "notesSegue", sender: nil)
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func handleMeet() {
        // TODO
        performSegue(withIdentifier: "tinderSegue", sender: nil)
    }
    
    @objc private func handleMenu() {
        let pullupMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if isUserCheckedIn! {
            pullupMenu.addAction(UIAlertAction(title: "Check Out", style: .default, handler: { (action) in
                self.handleCheckout()
            }))
        } else {
            pullupMenu.addAction(UIAlertAction(title: "Check In", style: .default, handler: { (action) in
                self.handleCheckin()
            }))
        }
        pullupMenu.addAction(UIAlertAction(title: "Chat", style: .default, handler: { (action) in
            self.handleChat()
        }))
        pullupMenu.addAction(UIAlertAction(title: "Meet", style: .default, handler: { (action) in
            self.handleMeet()
        }))
        pullupMenu.addAction(UIAlertAction(title: "Notes", style: .default, handler: { (action) in
            self.handleNotes()
        }))
        pullupMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        pullupMenu.actions[1].isEnabled = isUserCheckedIn!
        pullupMenu.actions[2].isEnabled = isUserCheckedIn!
        self.present(pullupMenu, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    let businessImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let businessInfoContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        userCoordinate?.latitude = locValue.latitude
//        userCoordinate?.longitude = locValue.longitude
        userCoordinate?.latitude = 22.3204
        userCoordinate?.longitude = 114.1698
        
        if !isUserCheckedIn! { return }
        let userLocation = CLLocation(latitude: userCoordinate!.latitude, longitude: userCoordinate!.longitude)
        let businessLocation = CLLocation(latitude: business.coordinate!.latitude, longitude: business.coordinate!.longitude)
        
        if userLocation.distance(from: businessLocation) > 600 {
            isUserCheckedIn = false
            let alert = UIAlertController(title: "Too Far Away", message: "You appear to be getting away from \(business.name!). Please get closer to check in again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isUserCheckedIn = false
        
        // Setup location manager
        userCoordinate = CLLocationCoordinate2D()
        locationManager = CLLocationManager()
        assert(CLLocationManager.locationServicesEnabled(), "Location service should be enabled.")
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.startUpdatingLocation()
        
        // Add business image
        view.addSubview(businessImageView)
        businessImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        businessImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        businessImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        businessImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // Add back button
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add menu button
        view.addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        menuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(businessInfoContainer)
        businessInfoContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        businessInfoContainer.topAnchor.constraint(equalTo: businessImageView.bottomAnchor).isActive = true
        businessInfoContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        businessInfoContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        // Add business title
        view.addSubview(businessTitleLabel)
        businessTitleLabel.leftAnchor.constraint(equalTo: businessInfoContainer.leftAnchor, constant: 8).isActive = true
        businessTitleLabel.topAnchor.constraint(equalTo: businessInfoContainer.topAnchor, constant: 8).isActive = true
        businessTitleLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 36).isActive = true
        businessTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Add bookmark button
        view.addSubview(bookmarkButton)
        bookmarkButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        bookmarkButton.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 16).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(businessTypeLabel)
        businessTypeLabel.topAnchor.constraint(equalTo: businessTitleLabel.bottomAnchor, constant: 8).isActive = true
        businessTypeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        businessTypeLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 16).isActive = true
        businessTypeLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        // Add status label
        view.addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: businessTypeLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        // Add hour label
        view.addSubview(hourLabel)
        hourLabel.topAnchor.constraint(equalTo: businessTypeLabel.bottomAnchor, constant: 8).isActive = true
        hourLabel.leftAnchor.constraint(equalTo: statusLabel.rightAnchor, constant: 4).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        // Add grey divider
        //        view.addSubview(greyLineDivider)
        //        greyLineDivider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //        greyLineDivider.topAnchor.constraint(equalTo: businessInfoContainer.bottomAnchor).isActive = true
        //        greyLineDivider.heightAnchor.constraint(equalToConstant: greyLineDividerHeight).isActive = true
        //        greyLineDivider.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension Date {
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
    
    func weekdayName(weekday: Int) -> String {
        switch weekday {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return "INVALID WEEKDAY"
        }
    }
}


















