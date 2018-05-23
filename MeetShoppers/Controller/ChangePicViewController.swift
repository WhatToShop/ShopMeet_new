//
//  ChangePicViewController.swift
//  MeetShoppers
//
//  Created by Bethany Bin on 5/22/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChangePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        let userid = Auth.auth().currentUser!.uid
        let ref = Firebase.Database.database().reference().child("users/\(userid)")
        if let uploadData = UIImagePNGRepresentation(selectedImageFromPicker!){
            let profilePictureKey = "users/\(userid)/profilePicture/profilePicture.jpg"
            let storageRef = Storage.storage().reference(withPath: profilePictureKey)
            let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            storageRef.putData(uploadData, metadata: uploadMetadata, completion: { (metadata, error) in
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        debugPrint(error)
                    }
                    else if let urlString = url?.absoluteString{
                        ref.child("photoUrl").setValue(urlString)
                    }
                })
            })
            
        }
    
        dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        goBack()
        

    }
    
    func goBack(){
        print("is it coming in go back")
        self.dismiss(animated: true)
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
