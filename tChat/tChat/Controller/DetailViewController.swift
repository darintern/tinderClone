//
//  DetailViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/10/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var headerView = UIView()
    var avatarImageView = UIImageView()
    var genderImageView = UIImageView()
    var ageLbl = UILabel()
    var usernameLbl = UILabel()
    var backBtn = UIButton()
    var sendBtn = UIButton()
    var detailTableView = UITableView()
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createConstraints()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//    }
    
    func setupViews() {
        setupDetailTableView()
        setupHeaderView()
    }
    
    func setupHeaderView() {
        view.addSubview(headerView)
        setupAvatarImageView()
        setupAgeLabel()
        setupGenderImageView()
        setupAgeLabel()
        setupBackButton()
        setupSendButton()
        setupUsernameLbl()
    }
}
