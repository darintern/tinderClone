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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_PROFILE, for: indexPath)
        if indexPath.section == 0 {
            let textField = UITextField()
            textField.text = sectionZero[indexPath.row]
            cell.addSubview(textField)
            textField.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
        } else if indexPath.section == 1 || indexPath.section == 2 {
            cell.accessoryType = .disclosureIndicator
            let label = UILabel()
            label.text = indexPath.section == 1 ? sectionOne[indexPath.row] : sectionTwo[indexPath.row]
            cell.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
        } else if indexPath.section == 3 {
            let btn = UIButton()
            btn.setTitle("Logout", for: .normal)
            btn.setTitleColor(.red, for: .normal)
            cell.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.centerX.centerY.equalToSuperview()
            }
        }
        return cell
        
    }
    
    
}
