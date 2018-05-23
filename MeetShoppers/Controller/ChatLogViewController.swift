//
//  ChatLogController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/23/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 16
        textField.sizeToFit()
        textField.clipsToBounds = true
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(rgb: 0xe6e6e6).cgColor
        textField.setLeftPaddingPoints(5)
        textField.setRightPaddingPoints(5)
        textField.delegate = self
        return textField
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.tag = 10
        button.setImage(#imageLiteral(resourceName: "chat-camera"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCamera), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let microphoneButton: UIButton = {
        let button = UIButton()
        button.tag = 25
        button.setImage(#imageLiteral(resourceName: "microphone"), for: UIControlState.normal)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMicrophone), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    var inputTextFieldRightAnchor: NSLayoutConstraint?
    var containerViewBottomAnchor: NSLayoutConstraint?
    var messages = [Message]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    var business: Business!
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
//        setupInputComponents()
//        setupKeyboardObservers()
        
        observeMessages()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48)
        containerView.backgroundColor = UIColor(rgb: 0xf5f5f5)
        
//        let uploadImaegView = UIImageView()
//        uploadImaegView.image = #imageLiteral(resourceName: "chat-camera")
//        uploadImaegView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(uploadImaegView)
//        uploadImaegView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
//        uploadImaegView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        uploadImaegView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        uploadImaegView.widthAnchor.constraint(equalToConstant: 32 ).isActive = true
        
        // Add send button to allow users to send text
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        containerView.addSubview(sendButton)
        
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Add microphone button
        containerView.addSubview(microphoneButton)
        microphoneButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        microphoneButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        microphoneButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add camera button
        containerView.addSubview(cameraButton)
        cameraButton.rightAnchor.constraint(equalTo: microphoneButton.leftAnchor, constant: -16).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add input text field
        containerView.addSubview(self.inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextFieldRightAnchor = inputTextField.rightAnchor.constraint(equalTo: cameraButton.leftAnchor, constant: -16)
        inputTextFieldRightAnchor!.isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -16).isActive = true
        
        // Add seperator line above the text field
//        let seperatorLineView = UIView()
//        seperatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
//        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(seperatorLineView)
//
//        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        return containerView
    }()
    
    @objc func handleCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("messages").child(imageName)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        if let imageData = UIImageJPEGRepresentation(originalImage, 1.0) {
            storageRef.putData(imageData, metadata: uploadMetadata) { (metadata, error) in
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        debugPrint(error)
                    } else if let urlString = url?.absoluteString {
                        print(urlString)
                    }
                })
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleMicrophone() {
        // TODO - Record voice
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get { return true }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        setupCell(cell: cell, message: message)
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = Firebase.Auth.auth().currentUser?.photoURL {
            cell.profileImageView.af_setImage(withURL: profileImageUrl)
        }
        
        let photoUrlRef = Firebase.Database.database().reference().child("users").child(message.fromId!)
        photoUrlRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.hasChild("photoUrl") {
                let photoUrlString = snapshot.childSnapshot(forPath: "photoUrl").value as! String
                let photoUrl = URL(string: photoUrlString)
                cell.profileImageView.af_setImage(withURL: photoUrl!)
            }
        }
        
        // Toggle between grey/blue message bubbles
        if message.fromId == Firebase.Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = UIColor(red: 240, green: 240, blue: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive  = true
        }
        
        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        // get estimated height somehow
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    // Update cell view and messages when a new message node is created in the database
    func observeMessages() {
//        let ref = Firebase.Database.database().reference().child("messages").child("businesses").child(business.id!)
        let ref = Database.database().reference().child("businesses").child(business.id!).child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
            }
        }) { (error) in
            debugPrint(error)
        }
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor!.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        // Add send button to allow users to send text
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Add input text field
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Add seperator line above the text field
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleSend() {
        var uid = "pseudo-uid"  // For testing
        if let currentUser = Firebase.Auth.auth().currentUser {
            uid = currentUser.uid
        }
        
        let timestamp = NSTimeIntervalSince1970
//        let ref = Firebase.Database.database().reference().child("messages").child("businesses").child(business.id!)
        let ref = Firebase.Database.database().reference().child("businesses").child(business.id!).child("messages")
        let childRef = ref.childByAutoId()
        let values: [String: Any] = [
            "text": inputTextField.text!,
            "fromId": uid,
            "timestamp": timestamp
        ]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}



















