//
//  PeopleViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class PeopleViewController: UIViewController {
    
    var users: [User] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchResults: [User] = []
    
    let peopleTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        observeUsers()
        setupViews()
        setupSearchController()
        createConstraints()
    }
    
    func observeUsers() {
        Api.User.observeUsers { (user) in
            self.users.append(user)
            self.peopleTableView.reloadData()
        }
    }
    
    func setupSearchController() {
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search users ..."
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupViews() {
        self.navigationItem.title = "People"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        peopleTableView.delegate = self
        peopleTableView.tableFooterView = UIView()
        peopleTableView.dataSource = self
        peopleTableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_USERS)
        view.addSubview(peopleTableView)
    }
    
    func createConstraints() {
        peopleTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
}
