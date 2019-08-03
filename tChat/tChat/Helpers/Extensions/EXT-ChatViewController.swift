//
//  EXT-ChatViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/2/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController {
    func setupPicker() {
        picker.delegate = self
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        setupAvatarImageView()
        setupTopLabel()
    }
    
    func setupTopLabel() {
        let attributedText = NSMutableAttributedString(string: partnerUsername + "\n", attributes: [.font : UIFont.systemFont(ofSize: 17) , .foregroundColor : UIColor.black])
        let attributedSubText = NSMutableAttributedString(string: "Active", attributes: [.font : UIFont.systemFont(ofSize: 13), .foregroundColor : UIColor.green])
        
        attributedText.append(attributedSubText)
        
        topLabel.attributedText = attributedText
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        
        navigationItem.titleView = topLabel
    }
    
    func setupAvatarImageView() {
        let imagePartnerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        avatarImageView.image = imagePartner
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.contentMode = .scaleAspectFill
        imagePartnerContainerView.addSubview(avatarImageView)
        
        let rightBarBtn = UIBarButtonItem(customView: imagePartnerContainerView)
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = .white
        chatTableView.separatorStyle = .none
        chatTableView.tableFooterView = UIView()
        chatTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_CHAT)
        view.addSubview(chatTableView)
    }
    
    func setupSeparatorView() {
        separatorView.backgroundColor = UIColor.rgbColor(r: 230, g: 230, b: 230, alpha: 1)
        view.addSubview(separatorView)
    }
    
    func setupInputMessageView() {
        inputMessageView.backgroundColor = .white
        view.addSubview(inputMessageView)
        setupInputMessageAttachmentBtn()
        setupInputMessageMicBtn()
        setupInputMessageSearchTextView()
        setupInputMessageSendBtn()
    }
    
    func setupInputMessageAttachmentBtn() {
        inputMessageAttachmentBtn.setImage(UIImage(named: "attachment_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        inputMessageAttachmentBtn.tintColor = .lightGray
        inputMessageAttachmentBtn.addTarget(self, action: #selector(attachmentBtnDidTaped), for: .touchUpInside)
        inputMessageView.addSubview(inputMessageAttachmentBtn)
    }
    
    func setupInputMessageMicBtn() {
        inputMessageMicBtn.setImage(UIImage(named: "mic")?.withRenderingMode(.alwaysTemplate), for: .normal)
        inputMessageMicBtn.tintColor = .lightGray
        inputMessageView.addSubview(inputMessageMicBtn)
    }
    
    func setupInputMessageSearchTextView() {
        inputMessageSearchTextView.delegate = self
        placeholderLbl.isHidden = false
        let placeholderFontSize = self.view.frame.size.width / 25
        print(placeholderFontSize)
        placeholderLbl.font = UIFont.init(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.text = "Write a message"
        placeholderLbl.textColor = .lightGray
        placeholderLbl.textAlignment = .left
        inputMessageSearchTextView.addSubview(placeholderLbl)
        
        inputMessageView.addSubview(inputMessageSearchTextView)
        
    }
    
    func setupInputMessageSendBtn() {
        inputMessageSendBtn.setTitle("Send", for: .normal)
        inputMessageSendBtn.setTitleColor(.black, for: .normal)
        inputMessageSendBtn.addTarget(self, action: #selector(sendBtnDidTaped), for: .touchUpInside)
        inputMessageView.addSubview(inputMessageSendBtn)
    }
    
    func observeMessages() {
        print("da")
        DispatchQueue.global(qos: .background).async {
            Api.Message.recieveMessage(from: Api.User.currentUserId, to: self.partnerId) { (message) in
                self.messages.append(message)
                self.sortMessages()
            }
            Api.Message.recieveMessage(from: self.partnerId, to: Api.User.currentUserId) { (message) in
                self.messages.append(message)
                self.sortMessages()
            }
        }
    }
    
    func sortMessages() {
        messages = self.messages.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
        }
        
    }
    
    func sendToFireBase(dict: Dictionary<String, Any>) {
        let date = Date().timeIntervalSince1970
        var value = dict
        value["from"] = Api.User.currentUserId
        value["to"] = partnerId
        value["date"] = date
        value["read"] = true
        
        Api.Message.sendMessage(from: Api.User.currentUserId, to: partnerId, value: value)
    }
    
    func createConstraints() {
        chatTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(inputMessageView.snp.top)
        }
        constraintsForSeparatorView()
        constraintsForInputMessageView()
        
    }
    
    func constraintsForSeparatorView() {
        separatorView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func constraintsForInputMessageView() {
        inputMessageView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorView.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        inputMessageAttachmentBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(8)
            make.height.width.equalTo(32)
        }
        inputMessageMicBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(inputMessageAttachmentBtn.snp.right).offset(8)
            make.height.width.equalTo(32)
        }
        inputMessageSearchTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(91)
            make.height.equalTo(30)
        }
        placeholderLbl.snp.makeConstraints { (make) in
            let placeholderX: CGFloat = self.view.frame.size.width / 75
            //            let placeholderY: CGFloat = 0
            //            let placeholderWidth = self.inputMessageSearchTextView.bounds.width - placeholderX
            //            let placeholderHeight = self.inputMessageSearchTextView.bounds.height
            make.left.equalTo(placeholderX)
            make.top.equalToSuperview()
            make.width.equalToSuperview().offset(placeholderX)
            make.height.equalToSuperview()
        }
        inputMessageSendBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(inputMessageSearchTextView.snp.right).offset(5)
            make.rightMargin.equalToSuperview().offset(-5)
            make.height.equalTo(30)
        }
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_CHAT, for: indexPath) as! MessageTableViewCell
        cell.playButton.isHidden = messages[indexPath.row].videoUrl == ""
        let uid = Api.User.currentUserId
        cell.configureCell(uid: uid, message: messages[indexPath.row], image: imagePartner)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let message = messages[indexPath.row]
        let text = message.text
        if !text.isEmpty {
            height = text.estimateFrameForText(text).height + 60
        }
        let heightMessage = message.height
        let widthMessage = message.width
        if heightMessage != 0, widthMessage != 0 {
            height = CGFloat(heightMessage / widthMessage * 250)
        }
        return height
    }
    
    
}


extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            placeholderLbl.isHidden = true
            inputMessageSendBtn.isEnabled = true
            inputMessageSendBtn.setTitleColor(.black, for: .normal)
        }
        else {
            placeholderLbl.isHidden = false
            inputMessageSendBtn.isEnabled = false
            inputMessageSendBtn.setTitleColor(.lightGray, for: .normal)
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            handleVideoSelectedForUrl(videoUrl)
        } else {
            handleImageSelectedForInfo(info)
        }
    }
    
    func handleVideoSelectedForUrl(_ url: URL) {
        let videoName = NSUUID().uuidString
        StorageService.saveVideoMessage(url: url, id: videoName, onSuccess: { (anyValue) in
            if let dict = anyValue as? [String: Any] {
                self.sendToFireBase(dict: dict)
            }
        }) { (error) in
            print(error)
        }
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey: Any]) {
        var selectedImageFromPicker: UIImage?
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = imageOriginal
        }
        //save photo
        
        let imageName = NSUUID().uuidString
        StorageService.savePhotoMessage(image: selectedImageFromPicker, id: imageName, onSuccess: { (anyValue) in
            if let dict = anyValue as? [String: Any] {
                self.sendToFireBase(dict: dict)
            }
        }) { (error) in
            print(error)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
