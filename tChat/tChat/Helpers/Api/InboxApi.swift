//
//  InboxApi.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/4/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

class InboxApi {
    func lastMessages(uid: String) {
        let ref = Ref().databaseInboxForUser(uid: uid)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                print(dict)
            }
        }
    }
}
