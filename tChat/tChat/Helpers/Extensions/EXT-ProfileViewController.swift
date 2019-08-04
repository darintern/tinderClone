//
//  EXT-ProfileViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/4/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

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


