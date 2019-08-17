//
//  EXT-MessagesTableView.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/4/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : inboxArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "New Matches" : "Messages"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_DEFAULT, for: indexPath)
            cell.addSubview(newMatchesCollectionView)
            newMatchesCollectionView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MESSAGES, for: indexPath) as! InboxTableViewCell
            //        cell.loadData(user)
            let inbox = inboxArray[indexPath.row]
            cell.controller = self
            cell.configureCell(uid: Api.User.currentUserId, inbox: inbox)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140.0
        } else {
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? InboxTableViewCell {
                let chatVC = ChatViewController()
                chatVC.imagePartner = cell.profileImageView.image!
                chatVC.partnerUsername = cell.usernameLbl.text!
                chatVC.partnerId = cell.user.uid
                chatVC.partnerUser = cell.user
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
}


extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newMatches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIER_CELL_NEW_MATCH, for: indexPath) as! NewMatchCollectionViewCell
        let user = newMatches[indexPath.row]
        cell.backgroundColor = .white
        cell.configureCell(user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NewMatchCollectionViewCell{
            let detailVc = DetailViewController()
            detailVc.user = cell.user
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
}
