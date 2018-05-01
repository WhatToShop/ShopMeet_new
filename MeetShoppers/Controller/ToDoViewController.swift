//
//  ToDoViewController.swift
//  MeetShoppers
//
//  Created by Kevin Nguyen on 4/14/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

struct note {
    let title: String!
    let message: String!
}

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var ref: DatabaseReference?
    var notes: [note] = []
    
    var noteData = [String: Any]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MADE IT INSIDE TODO VIEW CONTROLLER")
        self.title = "TODO"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let userID = Firebase.Auth.auth().currentUser!.uid
        ref = Database.database().reference()
    ref?.child("users").child(userID).child("Notes").observe(.childAdded, with: {snapShot in
        
            //let messageV = snapShot.childSnapshot(forPath: titleV).value as! String
        let messageV = ""
        self.notes.append(note(title: snapShot.key as! String,message: snapShot.value as! String))
        self.tableView.reloadData()
        
       })
        ref?.child("users").child(userID).child("Notes").observe(.childAdded, with: {(snapShot) in
          
        })
        // Do any additional setup after loading the view.
    }
    
    /*
     tableView.estimatedRowHeight = 100
     tableView.rowHeight = UITableViewAutomaticDimension
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoTableViewCell
        let todo = notes[indexPath.row]
        cell.titleLabel.text = todo.title
        cell.descriptionLabel.text = todo.message
        return cell
    }

}
