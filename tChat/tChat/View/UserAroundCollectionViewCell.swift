//
//  UsersAroundCollectionViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/9/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import Firebase
import SnapKit

class UserAroundCollectionViewCell: UICollectionViewCell {
    var avatar = UIImageView()
    var onlineStatusView = UIImageView()
    var ageLabel = UILabel()
    var distanceLabel = UILabel()
    var helperImageView = UIImageView()
    var user: User!
    var inboxChangedOnlineHandle: DatabaseHandle!
    var inboxChangedProfileHandle: DatabaseHandle!
    var controller: UsersAroundViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        setupOnlineStatusView()
        setupAvatar()
        setupAgeLabel()
        setupDistanceLabel()
        setupHelperImageView()
    }
    
    func setupAvatar() {
        avatar.contentMode = .scaleAspectFill
        addSubview(avatar)
    }
    
    func setupAgeLabel() {
        ageLabel.textColor = .white
        ageLabel.shadowColor = .black
        addSubview(ageLabel)
    }
    
    func setupDistanceLabel() {
        distanceLabel.textColor = .white
        distanceLabel.font = UIFont.systemFont(ofSize: 12)
        distanceLabel.shadowColor = .black
        addSubview(distanceLabel)
    }
    
    func setupOnlineStatusView() {
        onlineStatusView.backgroundColor = .red
        onlineStatusView.layer.cornerRadius = 10/2
        onlineStatusView.clipsToBounds = true
        addSubview(onlineStatusView)
    }
    
    func setupHelperImageView() {
        helperImageView.backgroundColor = UIColor.rgbColor(r: 0, g: 0, b: 0, alpha: 0.5)
        addSubview(helperImageView)
    }
    
    func createConstraints() {
        avatar.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        onlineStatusView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(4)
            make.width.height.equalTo(10)
        }
        ageLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.bottom.equalToSuperview()
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(6)
            make.top.equalTo(ageLabel)
        }
        helperImageView.snp.makeConstraints { (make) in
            make.height.equalTo(26)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func loadData(_ user: User) {
        self.user = user
        avatar.loadImage(user.profileImageUrl)
        if let age = user.age {
            self.ageLabel.text = "\(age)"
        } else {
            self.ageLabel.text = ""
        }
        
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
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        inboxChangedProfileHandle = refUser.observe(.childChanged) { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                self.controller.usersAroundCollectionView.reloadData()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let refOnline = Ref().databaseIsOnline(uid: self.user.uid)
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        onlineStatusView.backgroundColor = .red
    }
    
}
