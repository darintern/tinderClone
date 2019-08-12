//
//  MeViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import ProgressHUD
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var username = ""
    var email = ""
    var status = ""
    var sectionZero: [String] = ["", "", ""]
    let sectionOne = ["Privacy Policy", "Terms of Service"]
    let sectionTwo = ["Choose a walpaper"]
    let containerView = UIView()
    let avatar = UIImageView()
    var image: UIImage?
    var isMale: Bool?
    var age: Int?
    
    var profileTableView = UITableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        observeData()
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        setupNavBar()
        setupProfileTableView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnDidTaped))
    }
    
    @objc func saveBtnDidTaped() {
        ProgressHUD.show("Loading...")
        let usernameIndexPath = IndexPath(row: 0, section: 0)
        let emailIndexPath = IndexPath(row: 1, section: 0)
        let statusIndexPath = IndexPath(row: 2, section: 0)
        let ageIndexPath = IndexPath(row: 0, section: 1)
        let genderIndexPath = IndexPath(row: 1, section: 1)
        
        let usernameCell = profileTableView.cellForRow(at: usernameIndexPath) as! ProfileTableViewCell
        let emailCell = profileTableView.cellForRow(at: emailIndexPath) as! ProfileTableViewCell
        let statusCell = profileTableView.cellForRow(at: statusIndexPath) as! ProfileTableViewCell
        let ageCell = profileTableView.cellForRow(at: ageIndexPath) as! ProfileTableViewCell
        let genderCell = profileTableView.cellForRow(at: genderIndexPath) as! ProfileTableViewCell
        
        var dict = Dictionary<String, Any>()
        if let usernameValue = usernameCell.dataTextField.text, !usernameValue.isEmpty {
            dict["username"] = usernameValue
        }
        
        if let emailValue = emailCell.dataTextField.text, !emailValue.isEmpty {
            dict["email"] = emailValue
        }
        
        if let statusValue = statusCell.dataTextField.text, !statusValue.isEmpty {
            dict["status"] = statusValue
        }
        
        if let age = ageCell.dataTextField.text, !age.isEmpty {
            dict["age"] = age
        }
        
        dict["isMale"] = genderCell.segmentedControl.selectedSegmentIndex == 0 ? true : false
        
        Api.User.saveUserProfile(dict: dict, onSuccess: {
            if let img = self.image {
                StorageService.saveProfilePhoto(image: img, uid: Api.User.currentUserId, onSuccess: {
                    ProgressHUD.showSuccess()
                }) { (errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            }
            else {
                ProgressHUD.showSuccess()
            }
            ProgressHUD.showSuccess()
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupProfileTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_PROFILE)
        profileTableView.tableHeaderView = containerView
        view.addSubview(profileTableView)
        setupAvatar()
    }
    
    func setupAvatar() {
        avatar.image = UIImage()
        avatar.backgroundColor = .gray
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        avatar.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        containerView.addSubview(avatar)
    }
    
    func createConstraints() {
        profileTableView.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.centerX.width.top.equalToSuperview()
        }
        avatar.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(80)
        }
    }
    
    func observeData() {
        Api.User.getUserInfoSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.username = user.username
            self.email = user.email
            self.status = user.status
            self.sectionZero = [self.username, self.email, self.status]
            self.avatar.loadImage(user.profileImageUrl)
            if let age = user.age {
                self.age = age
            }
            if let isMale = user.isMale {
                self.isMale = isMale
            }
            self.profileTableView.reloadData()
        }
    }

}
