//
//  Ref.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/29/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import Firebase

let REF_USER = "users"
let REF_MESSAGE = "messages"
let REF_INBOX = "inbox"
let URL_STORAGE_ROOT = "gs://tchat-862a1.appspot.com"
let STORAGE_PROGILE = "profile"
let PROFILE_IMAGE_URL = "profileImageUrl"
let UID = "uid"
let EMAIL = "email"
let USERNAME = "username"
let STATUS = "status"
let ERROR_EMPTY_PHOTO = "Please choose your profile image"
let ERROR_EMPTY_EMAIL = "Please enter an email address"
let ERROR_EMPTY_USERNAME = "Please enter an username"
let ERROR_EMPTY_PASSWORD = "Please enter a password"
let ERROR_EMPTY_EMAIL_RESET = "Please enter an email address for password reset"
let SUCCESS_EMAIL_RESET = "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password"
let IDENTIFIER_CELL_USERS = "UsersTableViewCell"
let IDENTIFIER_CELL_CHAT = "ChatTableViewCell"
let IDENTIFIER_CELL_MESSAGES = "InboxTableViewCell"


class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    var datatabaseMessages: DatabaseReference {
        return databaseRoot.child(REF_MESSAGE)
    }
    
    func databaseMessageSendTo(from: String, to: String) -> DatabaseReference {
        return datatabaseMessages.child(from).child(to)
    }
    
    var databaseInbox: DatabaseReference {
        return databaseRoot.child(REF_INBOX)
    }
    
    func databaseInboxInfo(from: String, to: String) -> DatabaseReference {
        return databaseInbox.child(from).child(to)
    }
    
    func databaseInboxForUser(uid: String) -> DatabaseReference {
        return databaseInbox.child(uid)
    }
    
    // Storage Ref
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROGILE)
    }
    
    var storageMessage: StorageReference {
        return storageRoot.child(REF_MESSAGE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
    
    func storageSpecificImageMessage(id: String) -> StorageReference {
        return storageMessage.child("photo").child(id)
    }
    
    func storageSpecificVideoMessage(id: String) -> StorageReference {
        return storageMessage.child("video").child(id)
    }
    
}
