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
        var dict = Dictionary<String, Any>()
        if !username.isEmpty {
            dict["username"] = username
        }
        
        if !email.isEmpty {
            dict["email"] = email
        }
        
        if !status.isEmpty {
            dict["status"] = status
        }
        
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
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func logoutBtnDidTaped() {
        Api.User.isOnline(bool: false)
        Api.User.logout()
        
    }

    func setupProfileTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_PROFILE)
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
            self.profileTableView.reloadData()
        }
    }

}
