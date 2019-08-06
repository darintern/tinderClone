//
//  InboxApi.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/4/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import Firebase

typealias InboxCompletion = ((Inbox) -> Void)

class InboxApi {
    func lastMessages(uid: String, onSuccess: @escaping(InboxCompletion)) {
        let ref = Database.database().reference().child(REF_INBOX).child(uid)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                guard let partnerId = dict["to"] as? String else { return }
                let uid = (Api.User.currentUserId == partnerId) ? (dict["from"] as! String) : partnerId
                Api.User.getUserInfo(uid: uid, onSuccess: { (user) in
                    if let inbox = Inbox.transformInbox(dict: dict, user: user) {
                        onSuccess(inbox)
                    }
                })
                
            }
        }
    }
}
