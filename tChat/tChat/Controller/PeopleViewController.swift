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
    
    var peopleTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.definesPresentationContext = true
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
        searchController.dimsBackgroundDuringPresentation = false
        if let cancelButton = searchController.searchBar.value(forKey: "_cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        searchController.searchBar.placeholder = "Search users ..."
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupViews() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "People"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let location = UIBarButtonItem(image: UIImage(named: "icon-location"), style: .plain, target: self, action: #selector(locationDidTaped))
        navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationItem.leftBarButtonItem = location
    }
    
    @objc func locationDidTaped() {
        let usersAroundVC = UsersAroundViewController()
        self.navigationController?.pushViewController(usersAroundVC, animated: true)
    }
    
    func setupTableView() {
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
