//
//  MessagesViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class MessagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupViews()
        setLogoutBarBtn()
    }
    
    func setupViews() {
        
    }
    
    func setLogoutBarBtn() {
        let logoutBarBtn = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logoutBarBtnTapped))
        self.navigationItem.leftBarButtonItem = logoutBarBtn
    }
    
    @objc func logoutBarBtnTapped() {
        Api.User.logout()
    }
}
