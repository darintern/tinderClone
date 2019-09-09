//
//  ChatViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/30/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import MobileCoreServices
import AVFoundation

class ChatViewController: UIViewController {
    
    let chatTableView = UITableView()
    let inputMessageView = UIView()
    let inputMessageAttachmentBtn = UIButton()
    let inputMessageMicBtn = UIButton()
    let inputMessageSearchTextView = UITextView()
    let inputMessageSendBtn = UIButton()
    var imagePartner = UIImage()
    var avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    var partnerUsername = ""
    var partnerId = ""
    var partnerUser: User!
    var placeholderLbl = UILabel()
    var separatorView = UIView()
    var picker = UIImagePickerController()
    var messages = [Message]()
    var isActive = false
    var lastTimeOnline = ""
    var isTyping = false
    var timer = Timer()
    var refreshControl = UIRefreshControl()
    var lastMessageKey: String?
    var backBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        createConstraints()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupViews() {
        setupPicker()
        setupNavigationBar()
        setupTableView()
        setupSeparatorView()
        setupInputMessageView()
    }
    
    
    
    @objc func sendBtnDidTaped() {
        if let text = inputMessageSearchTextView.text, text != "" {
            inputMessageSearchTextView.text = ""
            self.textViewDidChange(inputMessageSearchTextView)
            sendToFireBase(dict: ["text": text as Any])
            chatTableView.layoutIfNeeded()
        }
    }
    
    @objc func attachmentBtnDidTaped() {
        let alert = UIAlertController(title: "tChat", message: "Select source", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take a picture", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavaliable")
            }
        }
        
        let library = UIAlertAction(title: "Choose an image or video", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavaliable")
            }
        }
        
        let videoCamera = UIAlertAction(title: "Take a video", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.picker.mediaTypes = [String(kUTTypeMovie)]
                self.picker.videoExportPreset = AVAssetExportPresetPassthrough
                self.picker.videoMaximumDuration = 30
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavaliable")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(videoCamera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

