//
//  InboxApi.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/4/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

typealias InboxCompletion = ((Inbox) -> Void)

class InboxApi {
    func lastMessages(uid: String, onSuccess: @escaping(InboxCompletion)) {
        let ref = Ref().databaseInboxForUser(uid: uid)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                Api.User.getUserInfo(uid: snapshot.key, onSuccess: { (user) in
                    if let inbox = Inbox.transformInbox(dict: dict, user: user) {
                        onSuccess(inbox)
                    }
                })
                
            }
        }
    }
}
