//
//  UserApi.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/29/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SnapKit
import GoogleSignIn
import ProgressHUD

class UserApi {
    
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
    func match(from: String,to: String, bool: Bool) {
        let ref = Ref().databaseNewMatchesForUser(uid: from).child(to)
        let dict: Dictionary<String, Any> = [
            "match": bool
        ]
        ref.updateChildValues(dict)
    }
    
    func typing(from: String, to: String) {
        let ref = Ref().databaseIsOnline(uid: from)
        let dict: Dictionary<String, Any> = [
            "typing": to
        ]
        ref.updateChildValues(dict)
    }
    
    func saveUserProfile(dict: [String: Any], onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {
        
        let ref = Ref().databaseSpecificUser(uid: currentUserId)
        ref.updateChildValues(dict) { (error, dataRef) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    func observeUsers(onSuccess: @escaping(UserCompletion)) {
        Ref().databaseUsers.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func observeNewMatchesForUser(uid: String, onSuccess: @escaping(UserCompletion)) {
        Ref().databaseNewMatchesForUser(uid: uid).observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                let partnerUid = Array(dict.keys)[0] // or .first
                self.getUserInfoSingleEvent(uid: partnerUid, onSuccess: { (user) in
                    if user.uid != Api.User.currentUserId {
                        onSuccess(user)
                    }
                })
                
            }
        }
    }
    
    func getUserInfoSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func getUserInfo(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func logout() {
        do {
            Api.User.isOnline(bool: false)
            if let providerData = Auth.auth().currentUser?.providerData {
                let userInfo = providerData[0]
                switch userInfo.providerID {
                case "google.com":
                    GIDSignIn.sharedInstance()?.signOut()
                default:
                    break
                }
            }
                
                
            try Auth.auth().signOut()
        }
        catch let error {
            ProgressHUD.showError(error.localizedDescription)
            return
        }
        (UIApplication.shared.delegate as! AppDelegate).confugureInitialViewController()
    }
    
    func resetPassword(with email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                onError(error!.localizedDescription)
            }
        }
    }
    
    func signIn(withEmail email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataRes, error) in
            if error != nil {
                onError(error!.localizedDescription)
            }
            onSuccess()
        }
        
    }
    
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authDataRes, err) in
            if err != nil {
                ProgressHUD.showError(err?.localizedDescription)
                return
            }
            if let userData = authDataRes {
                let dict: Dictionary<String, Any> = [
                    UID               : userData.user.uid,
                    EMAIL             : userData.user.email,
                    USERNAME          : username,
                    PROFILE_IMAGE_URL : "",
                    STATUS            : "Welcome to Tinder"
                ]
                
                guard let imageSelected = image else {
                    ProgressHUD.showError(ERROR_EMPTY_PHOTO)
                    
                    return
                }
                
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                    return
                }
                
                let storageProfile = Ref().storageSpecificProfile(uid: userData.user.uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                StorageService.savePhoto(username: username, uid: userData.user.uid, data: imageData, metadata: metadata, storageProfileRef: storageProfile, dict: dict, onSuccess: {
                    onSuccess()
                }, onError: { (err) in
                    onError(err)
                })
                
                
            }
        }
    }
    
    func isOnline(bool: Bool) {
        if !currentUserId.isEmpty {
            let ref = Ref().databaseIsOnline(uid: currentUserId)
            let dict: Dictionary<String, Any> = [
                "online": bool as Any,
                "latest": Date().timeIntervalSince1970 as Any
            ]
            ref.updateChildValues(dict)
        }
        
    }

}


typealias UserCompletion = (User) -> Void
