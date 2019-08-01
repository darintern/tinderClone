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
    }
    
    func setupPicker() {
        self.picker.delegate = self
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
        chatTableView.tableFooterView = UIView()
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
    
    @objc func sendBtnDidTaped() {
        if let text = inputMessageSearchTextView.text, text != "" {
            inputMessageSearchTextView.text = ""
            self.textViewDidChange(inputMessageSearchTextView)
            sendToFireBase(dict: ["text": text as Any])
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
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_CHAT, for: indexPath)
        return cell
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
    
    func handleVideoSelectedForUrl(_ video: URL) {
//        StorageService.saveVideoMessage
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
