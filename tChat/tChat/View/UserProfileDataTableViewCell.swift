//
//  UserProfileDataTableViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/7/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

class ProfileTableViewCell: UITableViewCell {
    var dataTextField = UITextField()
    var label = UILabel()
    let btn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        setupDataTextField()
        setupBtn()
        setupLabel()
    }
    
    func setupDataTextField() {
        dataTextField.isHidden = true
        addSubview(dataTextField)
    }
    
    func setupLabel() {
        label.isHidden = true
        addSubview(label)
    }
    
    func setupBtn() {
        btn.setTitle("Logout", for: .normal)
        btn.addTarget(self, action: #selector(logoutBtnDidTaped), for: .touchUpInside)
        btn.setTitleColor(.red, for: .normal)
        btn.isHidden = true
        addSubview(btn)
    }
    
    func createConstraints() {
        dataTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        btn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    @objc func logoutBtnDidTaped() {
        Api.User.isOnline(bool: false)
        Api.User.logout()
    }
}
