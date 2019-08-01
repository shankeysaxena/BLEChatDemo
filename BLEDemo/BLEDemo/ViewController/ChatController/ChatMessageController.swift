//
//  ViewController.swift
//  BLEDemo
//
//  Created by apple on 7/30/19.
//  Copyright © 2019 Shivam Saxena. All rights reserved.
//

import UIKit
import CoreBluetooth

class ChatMessageController: UICollectionViewController {
    
    var bluetoothConfigurator: BluetoothConfigurator?
    var deviceData: DeviceData?
    private var bottomContainerBottomConstraint: NSLayoutConstraint?
        
    private var bottomContainerView: UIView = {
        let bottomContainerView = UIView()
        bottomContainerView.backgroundColor = UIColor.defaultColor
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        return bottomContainerView
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your message here"
        textField.backgroundColor = .white
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = .white
        return sendButton
    }()
    
    //MARK:- View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupBottomContainerView()
        setupKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bluetoothConfigurator?.delegate = self
        if let advertisementData = deviceData?.deviceName.components(separatedBy: "|"), advertisementData.count > 0{
            navigationItem.title = advertisementData[0]
        } else {
            navigationItem.title = "Unkown"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //Method for sending message through bluetooth service
    func sendMessage() {
        if let text = inputTextField.text, text.count > 0{
            bluetoothConfigurator?.connectDeviceForSendingMessage()
            inputTextField.resignFirstResponder()
        }
    }
    
    //MARK:- Keyboard Notifications Methods
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillAppearNotification), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillAppearNotification(notification: Notification) {
        let keyBoardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        self.bottomContainerBottomConstraint?.constant = -keyBoardFrame.size.height
        let collectionViewBottomInset = keyBoardFrame.size.height + CGFloat(AppConstants.collectionViewBottomSpace)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: collectionViewBottomInset, right: 0)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHideNotification(notification: Notification) {
        let animationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        self.bottomContainerBottomConstraint?.constant = 0
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: CGFloat(AppConstants.collectionViewBottomSpace), right: 0)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
 
}

//MARK:- BluetoothConfiguratorDelegate Methods
extension ChatMessageController: BluetoothConfiguratorDelegate {
    func showAlertFor(_ errorString: String) {
        showAlertView("Error", message: errorString)
    }
    
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, with advertisementData: [String : Any]) {
        print(peripheral)
    }
    
    func writeValueWith(_ closure: (String) -> Void) {
        if let text = inputTextField.text, text.count > 0 {
            closure(text)
            appendMessage(message: text, isReply: false)
        }
    }
    
    func messageReceiveWith(_ data: Data?) {
        guard let data = data else {
            return
        }
        let messageText = String(data: data, encoding: String.Encoding.utf8) as String?
        appendMessage(message: messageText, isReply: true)
    }
}

//MARK:- Private Methods
private extension ChatMessageController {
    
    /// Method to append message in existing datasource and update collection view
    /// - Parameters:
    ///   - message: Text whihc has to be appended
    ///   - isReply: Message is reply or not
    func appendMessage(message: String?, isReply: Bool) {
        if let message = message {
            let chatMessage = ChatMessage(message: message, isReply: true)
            deviceData?.messages.append(chatMessage)
            collectionView.reloadData()
        }
    }

    //MARK:- UI Elements configuration methods
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.defaultColor
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.chatMessagesCellID.rawValue)
    }

    func setupBottomContainerView() {
        view.addSubview(bottomContainerView)
        bottomContainerBottomConstraint = bottomContainerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomContainerBottomConstraint?.isActive = true
        bottomContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        setupSendButton()
        setupInputTextField()
        setupSeparatorView()
    }
    
    func setupSeparatorView() {
        let separatorView = UIView()
        separatorView.backgroundColor = .darkGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: bottomContainerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: bottomContainerView.rightAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupSendButton() {
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        bottomContainerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: bottomContainerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: bottomContainerView.heightAnchor).isActive = true
    }
    
    @objc func sendButtonPressed() {
       sendMessage()
    }

    func setupInputTextField() {
        bottomContainerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: bottomContainerView.leftAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    }
}

