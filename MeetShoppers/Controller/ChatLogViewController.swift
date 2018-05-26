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
        button.setImage(#imageLiteral(resourceName: "chat-camera"), for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCamera), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let microphoneButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "microphone"), for: UIControlState.normal)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMicrophone), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "send-button"), for: UIControlState.normal)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: UIControlEvents.touchUpInside)
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
    
    let groupButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "group"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleGroup))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        
        // Add group button
        navigationItem.setRightBarButton(groupButton, animated: false)
        
        observeMessages()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48)
        containerView.backgroundColor = UIColor(rgb: 0xf5f5f5)
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // Add camera button
        containerView.addSubview(cameraButton)
        cameraButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -16).isActive = true
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

        return containerView
    }()
    
    @objc func handleGroup() {
        
    }
    
    @objc func handleCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
    
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadToFirebaseStorageUsingImage(image: originalImage)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("messages").child(imageName)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            storageRef.putData(imageData, metadata: uploadMetadata) { (metadata, error) in
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        debugPrint(error)
                    } else if let urlString = url?.absoluteString {
                        self.sendMessageWithImageUrl(imageUrl: urlString, image: image)
                    }
                })
            }
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        guard let currentUser = Firebase.Auth.auth().currentUser else { return }
        
        let uid = currentUser.uid
        let timestamp = NSTimeIntervalSince1970
        let ref = Firebase.Database.database().reference().child("businesses").child(business.id!).child("messages")
        let childRef = ref.childByAutoId()
        let values: [String: Any] = [
            "imageUrl": imageUrl,
            "imageHeight": image.size.height,
            "imageWidth": image.size.width,
            "fromId": uid,
            "timestamp": timestamp
        ]
        childRef.updateChildValues(values)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImaegView.af_setImage(withURL: URL(string: messageImageUrl)!)
            cell.messageImaegView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.text = ""
        } else {
            cell.messageImaegView.isHidden = true
        }
        
        if let text = message.text {
            cell.textView.text = text
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        // get estimated height somehow
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageUrl = messages[indexPath.item].imageUrl {
            height = 150
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
        let ref = Database.database().reference().child("businesses").child(business.id!).child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                self.scrollToBottom()
            }
        }) { (error) in
            debugPrint(error)
        }
    }
    
    @objc func handleSend() {
        guard let currentUser = Firebase.Auth.auth().currentUser else { return }
        
        let uid = currentUser.uid
        let timestamp = NSTimeIntervalSince1970
        let ref = Firebase.Database.database().reference().child("businesses").child(business.id!).child("messages")
        let childRef = ref.childByAutoId()
        let values: [String: Any] = [
            "text": inputTextField.text!,
            "fromId": uid,
            "timestamp": timestamp
        ]
        
        childRef.updateChildValues(values)
        inputTextField.text = ""
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}



















