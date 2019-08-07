//
//  MessageApi.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/31/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import Firebase

class MessageApi {
    func sendMessage(from: String, to: String, value: Dictionary<String, Any>) {
        let channelId = Message.hash(forMembers: [from, to])
        let ref = Database.database().reference().child("feedMessages").child(channelId)
        ref.childByAutoId().updateChildValues(value)
        
        var dict = value
        
        if let text = dict["text"] as? String, text.isEmpty {
            dict["imageUrl"] = nil
            dict["imageHeight"] = nil
            dict["imageWidth"] = nil
            
        }
        

        let refFromInbox = Database.database().reference().child(REF_INBOX).child(from).child(channelId)
        refFromInbox.updateChildValues(dict)
        
        let refToInbox = Database.database().reference().child(REF_INBOX).child(to).child(channelId)
        refToInbox.updateChildValues(dict)
        
//        let refFrom = Ref().databaseInboxInfo(from: from, to: to)
//        refFrom.updateChildValues(dict)
//
//        let refTo = Ref().databaseInboxInfo(from: to, to: from)
//        refTo.updateChildValues(dict)
    }
    
    func recieveMessage(from: String, to: String, onSuccess: @escaping(Message) -> Void) {
        let channelId = Message.hash(forMembers: [from, to])
        let ref = Database.database().reference().child("feedMessages").child(channelId)
        ref.queryOrderedByKey().queryLimited(toLast: 5).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let message = Message.transformMessage(dict: dict, keyId: snapshot.key) {
                    onSuccess(message)
                }
            }
        }
    }
    
    func loadMore(lastMessageKey: String?, from: String, to: String, onSuccess: @escaping([Message], String) -> Void) {
        if lastMessageKey != nil {
            let channelId = Message.hash(forMembers: [from, to])
            let ref = Database.database().reference().child("feedMessages").child(channelId)
            ref.queryOrderedByKey().queryEnding(atValue: lastMessageKey).queryLimited(toLast: 3).observeSingleEvent(of: .value) { (snapshot) in
                guard let first = snapshot.children.allObjects.first as? DataSnapshot else {
                    return
                }
                
                guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                    return
                }
                
                var messages = [Message]()
                
                allObjects.forEach({ (dataSnapshot) in
                    if let dict = dataSnapshot.value as? Dictionary<String, Any> {
                        if let message = Message.transformMessage(dict: dict, keyId: snapshot.key) {
                            if dataSnapshot.key != lastMessageKey {
                                messages.append(message)
                            }
                        }
                    }
                })
                onSuccess(messages, first.key)
                
            }
        }
    }
}
