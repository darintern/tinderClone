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
    var placeholderLbl = UILabel()
    var separatorView = UIView()
    var picker = UIImagePickerController()
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews() {
        setupPicker()
        setupNavigationBar()
        setupTableView()
        setupSeparatorView()
        setupInputMessageView()
        observeMessages()
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

