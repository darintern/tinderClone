//
//  File.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/29/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class StorageService {
    static func savePhoto(username: String, uid: String, imageData: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storageProfileRef.putData(imageData, metadata: metadata, completion: {
            (storageMetadata, err) in
            if err != nil {
                onError(err!.localizedDescription)
                return
            }
            storageProfileRef.downloadURL(completion: {
                (url, err) in
                if let metaUrl = url?.absoluteString {
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges(completion: { (error) in
                            if let error = error {
                                ProgressHUD.showError(error.localizedDescription)
                            }
                        })
                    
                    }
                    
                    var dictTemp = dict
                    dictTemp[PROFILE_IMAGE_URL] = metaUrl
                    Ref().databaseSpecificUser(uid: uid).updateChildValues(dict, withCompletionBlock: {
                        (err, databaseRef) in
                        if err != nil {
                            onError(err!.localizedDescription)
                            return
                        } else {
                            onSuccess()
                        }
                    })
                }
                
            })
        })
    }
}
