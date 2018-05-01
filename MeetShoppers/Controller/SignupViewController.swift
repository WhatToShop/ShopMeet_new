//
//  SignupViewController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/6/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: BottomBorderedTextField!
    @IBOutlet weak var passwordTextField: BottomBorderedTextField!
    @IBOutlet weak var confirmPasswordTextField: BottomBorderedTextField!
    @IBOutlet weak var signupView: UIView!
    
    var signupViewOriginalCenter: CGPoint!
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        // Customize signin button
        signinButton.backgroundColor = UIColor(rgb: 0x2BC2C2)
        signinButton.layer.cornerRadius = 22
        signinButton.clipsToBounds = true
        
        // Create circular camera button
        cameraButton.layer.cornerRadius = 0.5 * cameraButton.bounds.size.width
        cameraButton.clipsToBounds = true
        
        // Add tap gesture recognizer to dismiss the keyboard when user tap on screen and keyboard is opened
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Initialzed sign up view original center
        signupViewOriginalCenter = signupView.center
    }
    
    // Push view to the top when user begins editing in the text fields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cameraButton.isEnabled = false
        cameraButton.isHidden = true
        descriptionLabel.isHidden = true
        signupView.center = CGPoint(x: view.center.x, y: view.center.y*0.6)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cameraButton.isEnabled = true
        cameraButton.isHidden = false
        descriptionLabel.isHidden = false
        signupView.center = CGPoint(x: signupViewOriginalCenter.x, y: signupViewOriginalCenter.y)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // Put profile image to storage if user has taken/choosen a picture during sign up
    func uploadProfileImageToFirebaseStorage(data: Data) {
        let userid = Auth.auth().currentUser!.uid
        let profilePictureKey = "users/\(userid)/profilePicture/profilePicture.jpg"
        let storageRef = Storage.storage().reference(withPath: profilePictureKey)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        let uploadTask = storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                self.displayMessageDialog(title: "Error", message: error.localizedDescription)
            } else {
                // Update user's photo url if profile picture is saved
                guard case Auth.auth().currentUser!.createProfileChangeRequest().photoURL!? = URL(string: profilePictureKey) else { return }
            }
        }
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        if email.count == 0 {
            self.displayMessageDialog(title: "Empty Email", message: "Email is empty. Please try again")
            return
        }
        
        if password.count == 0 {
            self.displayMessageDialog(title: "Empty Password", message: "Password is empty. Please try again.")
            return
        }
        
        if confirmPassword != password {
            self.displayMessageDialog(title: "Incorrect Password", message: "Passwords do not match. Please try again.")
            return 
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                    self.displayMessageDialog(title: "Unknown Error", message: "Please try again.")
                    return
                }
                
                switch errorCode {
                case .invalidEmail:
                    self.displayMessageDialog(title: "Invalid email address.", message: "Please try again.")
                    break
                case .emailAlreadyInUse:
                    self.displayMessageDialog(title: "Existing Email", message: "Email already exists. Please try again.")
                case .weakPassword:
                    self.displayMessageDialog(title: "Weak Password", message: "Password is too weak. Please try again.")
                case .networkError:
                    self.displayMessageDialog(title: "Network Error", message: "Your Internet is too weak. Please try again.")
                default:
                    self.displayMessageDialog(title: "Unknwon Error", message: "Please try again.")
                }
            } else {
                // Send email verification to the user when there is no error
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in})
           
                // Set user profile picture if user picks/takes a picture when sign up
                if let image = self.profileImage, let imageData = UIImageJPEGRepresentation(image, 1.0) {
                    self.uploadProfileImageToFirebaseStorage(data: imageData)
                }
                
                // Write new user data to the database
                self.writeUserData(uid: Auth.auth().currentUser?.uid, name: "Test User", email: email, imageUrl: "Test Image URL")
                
                self.performSegue(withIdentifier: "signinSegue", sender: nil)
                let alert = UIAlertController(title: "Success", message: "You have successfully signed in. Please log in to to enjoy the unique shopping experience.", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    func writeUserData(uid: String?, name: String?, email: String?, imageUrl: String?) {
        guard let uid = uid else { return }
        
    //    let ref = Firebase.Database.database().reference().child("users").child(uid).
        
    
    
    }
    
    @IBAction func onSignin(_ sender: UIButton) {
        performSegue(withIdentifier: "signinSegue", sender: nil)
    }
    
    // When user taps on camera, allows user to add/ remove profile picture
    @IBAction func onCamera(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // Display alert view to let user choose whether to pick a photo from library or take a picture
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            picker.sourceType = .camera
            self.present(picker, animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action) in
            self.cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: UIControlState.normal)
            self.profileImage = nil
            alert.dismiss(animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    func displayMessageDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage = originalImage
        cameraButton.setImage(profileImage, for: UIControlState.normal)
        picker.dismiss(animated: false, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view
        if segue.identifier == "signinSegue" {
            let vc = segue.destination as! SigninViewController
            vc.email = self.emailTextField.text!
        }
    }
}
