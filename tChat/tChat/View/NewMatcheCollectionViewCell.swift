//
//  NewMatcheCollectionViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/16/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

class NewMatchCollectionViewCell: UICollectionViewCell {
    var user: User!
    var userProfileImageView = UIImageView()
    var usernameLbl = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(user: User) {
        self.user = user
        self.usernameLbl.text = user.username
        self.userProfileImageView.image = user.profileImage
    }
    
    func setupViews() {
        usernameLbl.textAlignment = .center
        userProfileImageView.layer.cornerRadius = 40
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        addSubview(userProfileImageView)
        addSubview(usernameLbl)
    }
    
    func createConstraints() {
        userProfileImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.width.equalTo(80)
        }
        
        usernameLbl.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(userProfileImageView.snp.bottom).offset(10)
        }
    }
}
