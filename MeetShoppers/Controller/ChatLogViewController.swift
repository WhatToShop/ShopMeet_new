//
//  ChatLogController.swift
//  MeetShoppers
//
//  Created by Kelvin Lui on 4/23/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        // Add send button to allow users to send text a
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
        containerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Add seperator line above the text field
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    var containerBottomAnchor: NSLayoutConstraint?
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
        
        observeMessages()
//        setupKeyboardObservers()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        containerBottomAnchor?.constant = 0
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        containerBottomAnchor?.constant = -keyboardFrame!.height
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
    
    // Scroll collection view to the bottom to see the latest messages
    func scrollToBottom() {
        var item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        var lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: false)
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        // Add send button to allow users to send text a
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSend() {
        guard let currentUser = Firebase.Auth.auth().currentUser else { return }
        
        let timestamp = NSTimeIntervalSince1970
        let ref = Firebase.Database.database().reference().child("businesses").child(business.id!).child("messages")
        let childRef = ref.childByAutoId()
        let values: [String: Any] = [
            "text": inputTextField.text!,
            "fromId": currentUser.uid,
            "timestamp": timestamp
        ]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
