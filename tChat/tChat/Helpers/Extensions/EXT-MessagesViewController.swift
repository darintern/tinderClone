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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MESSAGES, for: indexPath) as! InboxTableViewCell
//        cell.loadData(user)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0; //Choose your custom row height
    }
    
    
}
