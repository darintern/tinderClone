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
        return inboxArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MESSAGES, for: indexPath) as! InboxTableViewCell
//        cell.loadData(user)
        let inbox = inboxArray[indexPath.row]
        cell.configureCell(uid: Api.User.currentUserId, inbox: inbox)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0; //Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? InboxTableViewCell {
            let chatVC = ChatViewController()
            chatVC.imagePartner = cell.profileImageView.image!
            chatVC.partnerUsername = cell.usernameLbl.text!
            chatVC.partnerId = cell.user.uid
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
}
