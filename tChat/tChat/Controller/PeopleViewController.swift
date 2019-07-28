//
//  PeopleViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit

class PeopleViewController: UIViewController {
    
    static let cellId = "cellId"
    
    let peopleTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        self.navigationItem.title = "People"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        peopleTableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleViewController.cellId)
        view.addSubview(peopleTableView)
    }
    
    func createConstraints() {
        peopleTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleViewController.cellId, for: indexPath) as! PeopleTableViewCell
        cell.fullNameLabel.text = "Taylor Swift"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    
}


class PeopleTableViewCell: UITableViewCell {
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "taylor_swift")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
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
            make.baseline.equalTo(profileImageView)
            make.width.height.equalTo(36)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
