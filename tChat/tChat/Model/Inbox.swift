//
//  Message.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/1/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

class Inbox {
    var user: User
    var read: Bool
    var date: Double
    var text: String
    var channel: String
    
    init(user: User, read: Bool, date: Double, text: String, channel: String) {
        self.date = date
        self.user = user
        self.read = read
        self.text = text
        self.channel = channel
    }
    
    static func transformInbox(dict: [String: Any], channel: String, user: User) -> Inbox? {
        guard let text = dict["text"] as? String,
            let read = dict["read"] as? Bool,
            let date = dict["date"] as? Double else {
                return nil
        }
        
        let inbox = Inbox(user: user, read: read, date: date, text: text, channel: channel)
        
        return inbox
    }
    
    func updateData(key: String, value: Any) {
        switch key {
        case "text": self.text = value as! String
        case "date": self.date = value as! Double
        default: break
        }
    }
}
