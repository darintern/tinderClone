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
    let logoutBtn = UIButton()
    var segmentedControl = UISegmentedControl(items: ["Male", "Female"])
    
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
        setupSegmentedControl()
        setupBtn()
        setupLabel()
    }
    
    func setupDataTextField() {
        dataTextField.isHidden = true
        addSubview(dataTextField)
    }
    
    func setupSegmentedControl() {
        segmentedControl.isHidden = true
        segmentedControl.tintColor = PURPLE_COLOR
        segmentedControl.selectedSegmentIndex = 0
        addSubview(segmentedControl)
    }
    
    func setupLabel() {
        label.isHidden = true
        addSubview(label)
    }
    
    func setupBtn() {
        // logout
        logoutBtn.setTitle("Logout", for: .normal)
        logoutBtn.addTarget(self, action: #selector(logoutBtnDidTaped), for: .touchUpInside)
        logoutBtn.setTitleColor(.red, for: .normal)
        logoutBtn.isHidden = true
        addSubview(logoutBtn)
    }
    
    func createConstraints() {
        dataTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        logoutBtn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        segmentedControl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    @objc func logoutBtnDidTaped() {
        Api.User.isOnline(bool: false)
        Api.User.logout()
    }
}
