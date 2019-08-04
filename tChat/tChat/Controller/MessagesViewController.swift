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

    let messagesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupViews()
        setLogoutBarBtn()
        createConstraints()
        observeInbox()
    }
    
    func observeInbox() {
        Api.Inbox.lastMessages(uid: Api.User.currentUserId)
    }
    
    func setupViews() {
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        messagesTableView.delegate = self
        messagesTableView.tableFooterView = UIView()
        messagesTableView.dataSource = self
        messagesTableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_MESSAGES)
        view.addSubview(messagesTableView)
    }

    func setLogoutBarBtn() {
        let logoutBarBtn = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logoutBarBtnTapped))
        self.navigationItem.leftBarButtonItem = logoutBarBtn
    }
    
    func createConstraints() {
        messagesTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc func logoutBarBtnTapped() {
        Api.User.logout()
    }
}
