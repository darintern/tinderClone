//
//  EXT-PeopleViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/3/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //        print(searchController.searchBar.text)
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            view.endEditing(true)
        } else {
            let lowercasedText = searchController.searchBar.text!.lowercased()
            filterContent(for: lowercasedText)
        }
        self.peopleTableView.reloadData()
    }
    
    func filterContent(for searchText: String) {
        searchResults = self.users.filter {
            return $0.username.lowercased().range(of: searchText) != nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_USERS, for: indexPath) as! PeopleTableViewCell
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.loadData(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0; //Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? PeopleTableViewCell {
            let chatVC = ChatViewController()
            chatVC.imagePartner = cell.profileImageView.image!
            chatVC.partnerUsername = cell.fullNameLabel.text!
            chatVC.partnerId = cell.user.uid
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
}
