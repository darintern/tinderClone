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

    var inboxArray = [Inbox]()
    
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
        Api.Inbox.lastMessages(uid: Api.User.currentUserId) { (inbox) in
            if !self.inboxArray.contains(where: { $0.user.uid == inbox.user.uid}) {
                self.inboxArray.append(inbox)
                self.sortedInbox()
            }
        }
    }
    
    func sortedInbox() {
        inboxArray = self.inboxArray.sorted(by: { $0.date > $1.date })
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
            self.messagesTableView.scrollToRow(at: IndexPath(row: self.inboxArray.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func setupViews() {
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        messagesTableView.delegate = self
        messagesTableView.tableFooterView = UIView()
        messagesTableView.dataSource = self
        messagesTableView.register(InboxTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_MESSAGES)
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
