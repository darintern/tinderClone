//
//  MeViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    var username = ""
    var email = ""
    var status = ""
    var sectionZero: [String] = ["", "", ""]
    let sectionOne = ["Privacy Policy", "Terms of Service"]
    let sectionTwo = ["Choose a walpaper"]
    let containerView = UIView()
    let profileImageView = UIImageView()
    
    var profileTableView = UITableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        observeData()
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        setupProfileTableView()
    }
    
    func setupProfileTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_PROFILE)
        profileTableView.tableHeaderView = containerView
        view.addSubview(profileTableView)
        setupProfileImageView()
    }
    
    func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        containerView.addSubview(profileImageView)
    }
    
    func createConstraints() {
        profileTableView.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.centerX.width.top.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(80)
        }
    }
    
    func observeData() {
        Api.User.getUserInfo(uid: Api.User.currentUserId) { (user) in
            self.username = user.username
            self.email = user.email
            self.status = user.status
            self.sectionZero = [self.username, self.email, self.status]
            self.profileImageView.loadImage(user.profileImageUrl)
            self.profileTableView.reloadData()
        }
    }

}
