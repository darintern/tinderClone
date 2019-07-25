//
//  ViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SnapKit

class ViewController: UIViewController {

    let avatar: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage()
        iv.backgroundColor = .blue
        return iv
    }()
    
    let signUpBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        signUpDidTaped()
        setupViews()
        makeConstraints()
        
        
    }
    
    
    func setupViews() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        
        signUpBtn.backgroundColor = .blue
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.addTarget(self, action: #selector(signUpDidTaped), for: .touchUpInside)

        view.addSubview(avatar)
        view.addSubview(signUpBtn)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func makeConstraints() {
        avatar.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(100)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        signUpBtn.snp.makeConstraints {
            (make) in
            make.top.equalTo(avatar.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    
    
    
    
    
    //MARK - Actions
    @objc func signUpDidTaped() {
        
        guard let selectedImage = avatar.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.4) else {
            return
        }

        
        Auth.auth().createUser(withEmail: "email114421321@mail.ru", password: "1234567") {
            (authDataRes, err) in
            if err != nil {
                print(err?.localizedDescription)
                return
            }
            if let userData = authDataRes {
                var dict: Dictionary<String, Any> = [
                    "uid"             : userData.user.uid,
                    "email"           : userData.user.email,
                    "profileImageUrl" : "",
                    "status"          : "Welcome to Tinder"
                ]
                
                let storageRef = Storage.storage().reference(forURL: "gs://tchat-862a1.appspot.com")
                let storageProfileRef = storageRef.child("profile").child(userData.user.uid)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                storageProfileRef.putData(imageData, metadata: metadata, completion: {
                    (storageMetadata, err) in
                    if err != nil {
                        print(err?.localizedDescription)
                        return
                    }
                    storageProfileRef.downloadURL(completion: {
                        (url, err) in
                        if let metaUrl = url?.absoluteString {
                            dict["profileImageUrl"] = metaUrl
                        Database.database().reference().child("users").child(userData.user.uid).updateChildValues(dict, withCompletionBlock: {
                                (err, databaseRef) in
                                    if err != nil {
                                        print(err?.localizedDescription)
                                        return
                                    }
                            print("Done !")
                                
                            })
                        }
                    
                    })
                })
                
            }
        }
    }
    


}



extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatar.image = imageSelected
            print("selected")
            avatar.backgroundColor = .none
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatar.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
