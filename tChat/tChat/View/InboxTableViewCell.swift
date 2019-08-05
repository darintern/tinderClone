//
//  PeopleTableViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/3/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

class InboxTableViewCell: UITableViewCell {
    var user: User!
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let usernameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let messageLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Welcome to tChat"
        return label
    }()
    let dateLbl: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Welcome to tChat"
        return label
    }()
    var onlineStatusView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.createConstraints()
    }
    
    func configureCell(uid: String, inbox: Inbox) {
        self.user = inbox.user
        profileImageView.loadImage(inbox.user.profileImageUrl)
        usernameLbl.text = user.username
        let date = Date(timeIntervalSince1970: inbox.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLbl.text = dateString
        messageLbl.text = inbox.text
        
        if inbox.text.isEmpty {
            messageLbl.text = "MEDIA"
        }
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLbl)
        addSubview(dateLbl)
        addSubview(messageLbl)
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
        usernameLbl.text = user.username
        profileImageView.loadImage(user.profileImageUrl)
    }
    
    
    func createConstraints() {
        profileImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        onlineStatusView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(profileImageView)
            make.height.width.equalTo(15)
        }
        usernameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(25)
        }
        messageLbl.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(15)
            make.top.equalTo(usernameLbl.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-20)
        }
        dateLbl.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(usernameLbl.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

