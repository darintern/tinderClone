//
//  PeopleTableViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/3/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PeopleTableViewCell: UITableViewCell {
    var user: User!
    var onlineStatusView = UIView()
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let fullNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let statusTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to tChat"
        return label
    }()
    let chatIconImageView: UIImageView = {
        let chatIconIV = UIImageView()
        chatIconIV.image = UIImage(named: "icon-chat")
        chatIconIV.clipsToBounds = true
        chatIconIV.contentMode = .scaleAspectFit
        return chatIconIV
    }()
    var inboxChangedOnlineHandle: DatabaseHandle!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.createConstraints()
    }
    //    init(fullName: String, statusText: String, profileImageName: String) {
    //        super.init(style: .default, reuseIdentifier: PeopleViewController.cellId)
    //        fullNameLabel.text = fullName
    //        statusTextLabel.text = statusText
    //        profileImageView.image = UIImage(named: profileImageName)
    //    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(chatIconImageView)
        addSubview(fullNameLabel)
        addSubview(statusTextLabel)
        setupOnlineStatusView()
    }
    
    func setupOnlineStatusView() {
        onlineStatusView.backgroundColor = .red
        onlineStatusView.layer.cornerRadius = 15/2
        onlineStatusView.layer.borderColor = UIColor.white.cgColor
        onlineStatusView.layer.borderWidth = 2
        onlineStatusView.clipsToBounds = true
        addSubview(onlineStatusView)
    }
    
    func loadData(_ user: User) {
        self.user = user
        fullNameLabel.text = user.username
        statusTextLabel.text = user.status
        profileImageView.loadImage(user.profileImageUrl)
        
        let refOnline = Ref().databaseIsOnline(uid: user.uid)
        refOnline.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, Any> {
                if let active = snap["online"] as? Bool {
                    self.onlineStatusView.backgroundColor = active == true ? .green : .red
                }
            }
        }
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        inboxChangedOnlineHandle = refOnline.observe(.childChanged) { (snapshot) in
            if let snap = snapshot.value {
                if snapshot.key == "online" {
                    self.onlineStatusView.backgroundColor = (snap as! Bool) == true ? .green : .red
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let refOnline = Ref().databaseIsOnline(uid: self.user.uid)
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        onlineStatusView.backgroundColor = .red
    }
    
    
    func createConstraints() {
        profileImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        fullNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(25)
        }
        statusTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(15)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(5)
        }
        chatIconImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(36)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        onlineStatusView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(profileImageView)
            make.height.width.equalTo(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

