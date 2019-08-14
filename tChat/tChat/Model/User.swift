//
//  User.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/30/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    var profileImage: UIImage?
    var status: String
    var isMale: Bool?
    var age: Int?
    var latitude = ""
    var longitude = ""
    
    init(uid: String, username: String, email: String, profileImageUrl: String, status: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.status = status
    }
    
    static func transformUser(dict: [String: Any]) -> User? {
        guard let email = dict[EMAIL] as? String,
            let username = dict[USERNAME] as? String,
            let profileImageUrl = dict[PROFILE_IMAGE_URL] as? String,
            let status = dict[STATUS] as? String,
            let uid = dict[UID] as? String else {
                return nil
        }
        let user = User(uid: uid, username: username, email: email, profileImageUrl: profileImageUrl, status: status)
        if let isMale = dict["isMale"] as? Bool {
            user.isMale = isMale
        }
        if let age = dict["age"] as? String {
            user.age = Int(age)
        }
        if let latitude = dict[LATITUDE] as? String {
            user.latitude = latitude
        }
        if let longitude = dict[LONGITUDE] as? String {
            user.longitude = longitude
        }
        
        let profileImageView = UIImageView()
        profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "Aibol"), options: .continueInBackground, completed: nil)
        user.profileImage = profileImageView.image

        return user
    }
    
    func updateData(key: String, value: String) {
        switch key {
            case "username": self.username = value
            case "email": self.email = value
            case "profileImageUrl": self.profileImageUrl = value
            case "status": self.status = value
            default: break
        }
    }
}


extension User {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
