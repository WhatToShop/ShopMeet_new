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

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var ref: DatabaseReference?
    var notes: [note] = []
    var noteFilter: [note] = []
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad was called in TodoViewController")
        self.title = "TODO"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNoteAction(_:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        updateTableView()
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear To Do View Controller")
        updateTableView()
    }

    func updateTableView() {
        print("In updateTableView")
        notes = []
        noteFilter = []
        let userID = Firebase.Auth.auth().currentUser!.uid
        ref = Database.database().reference()
        ref?.child("users").child(userID).child("Notes").observe(.childAdded, with: {snapShot in
            
            if( self.notes.count == 0 || snapShot.key as! String != self.notes[self.notes.count-1].title){
                self.notes.append(note(title: snapShot.key as! String, message: snapShot.value as! String))
                self.noteFilter.append(note(title: snapShot.key as! String, message: snapShot.value as! String))
            
             self.tableView.reloadData()
                print("Title11: ", snapShot.key)
            print("value: ", snapShot.value)
                }// checking condition to make sure there are no duplicates
        })
        ref?.child("users").child(userID).child("Notes").observe(.childAdded, with: {(snapShot) in
            
        })
       
    }
    
    /* Make sure to delete this , only used for testing*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func addNoteAction(_ sender: Any) {
        print("add Note action")
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupStoreID") as! ObjPopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        updateTableView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoTableViewCell
        cell.Note = noteFilter[indexPath.row]
        
        return cell
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noteFilter = searchText.isEmpty ? notes : notes.filter { (item: note) -> Bool in
        return item.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
        print("Made it to seaerch bar changes")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "noteSegue"{
            let vc = segue.destination as? IndividualNoteViewController
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let note = noteFilter[indexPath.row]
                let detailViewController = segue.destination as! IndividualNoteViewController
                detailViewController.singleNote = note
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let note = self.noteFilter[indexPath.row]
            let userID = Firebase.Auth.auth().currentUser!.uid
            print("TITLE", note.title)
            let referenceChild = ref?.child("users").child(userID).child("Notes").child(note.title)
            print("about to delete")
            referenceChild?.removeValue { error, _ in
                
                print(error)
            }
            noteFilter.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
