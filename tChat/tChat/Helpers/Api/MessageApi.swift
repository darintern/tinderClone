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
        
        var dict = value
        
        if let text = dict["text"] as? String, text.isEmpty {
            dict["imageUrl"] = nil
            dict["imageHeight"] = nil
            dict["imageWidth"] = nil
            
        }
        
        
        let refFrom = Ref().databaseInboxInfo(from: from, to: to)
        refFrom.updateChildValues(dict)
        
        let refTo = Ref().databaseInboxInfo(from: to, to: from)
        refTo.updateChildValues(dict)
    }
    
    func recieveMessage(from: String, to: String, onSuccess: @escaping(Message) -> Void) {
        let ref = Ref().databaseMessageSendTo(from: from, to: to)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let message = Message.transformMessage(dict: dict, keyId: snapshot.key) {
                    onSuccess(message)
                }
            }
        }
    }
}
