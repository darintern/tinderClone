//
//  MessageApi.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/31/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

class MessageApi {
    func sendMessage(from: String, to: String, value: Dictionary<String, Any>) {
        let ref = Ref().databaseMessageSendTo(from: from, to: to)
        ref.childByAutoId().updateChildValues(value)
    }
}
