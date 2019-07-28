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

class SignUpViewController: UIViewController {

    var closeBtn: UIButton!
    var titleLabel: UILabel!
    var avatar: UIImageView!
    var wrapperViewForFullName: UIView!
    var fullNameTextField: UITextField!
    var wrapperViewForEmail: UIView!
    var emailAddressTextField: UITextField!
    var wrapperViewForPassword: UIView!
    var passwordTextField: UITextField!
    var signUpBtn: UIButton!
    var alreadyHaveAccountBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        makeConstraints()
    }
    
    func setupViews() {
        setupCloseBtn()
        setupTitleLabel()
        setupAvatar()
        setupWrapperViewForFullName()
        setupFullNameTextField()
        setupWrapperViewForEmail()
        setupEmailAddressTextField()
        setupWrapperViewForPassword()
        setupPasswordTextField()
        setupSignUpBtn()
        setupAlreadyHaveAccountBtn()
        
    }
    
    func constraintsForCloseBtn() {
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    func constraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    func constraintsForAvatar() {
        avatar.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
    }
    
    func constraintsForWrapperViewFullName() {
        wrapperViewForFullName.snp.makeConstraints { (make) in
            make.top.equalTo(avatar.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func constraintsForFullNameTextField() {
        fullNameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func constraintsForWrapperViewEmail() {
        wrapperViewForEmail.snp.makeConstraints { (make) in
            make.top.equalTo(wrapperViewForFullName.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func constraintsForEmailAddressTextField() {
        emailAddressTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func constraintsForWrapperViewPassword() {
        wrapperViewForPassword.snp.makeConstraints { (make) in
            make.top.equalTo(wrapperViewForEmail.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func constraintsForPasswordTextField() {
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func constraintsForSignUpBtn() {
        signUpBtn.snp.makeConstraints {
            (make) in
            make.top.equalTo(wrapperViewForPassword.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func constraintsForAlreadyHaveAccountBtn() {
        alreadyHaveAccountBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signUpBtn.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    
    func makeConstraints() {
        constraintsForCloseBtn()
        constraintsForTitleLabel()
        constraintsForAvatar()
        constraintsForWrapperViewFullName()
        constraintsForFullNameTextField()
        constraintsForWrapperViewEmail()
        constraintsForEmailAddressTextField()
        constraintsForWrapperViewPassword()
        constraintsForPasswordTextField()
        constraintsForSignUpBtn()
        constraintsForAlreadyHaveAccountBtn()
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

        
        Auth.auth().createUser(withEmail: "aibolseed@gmail.com", password: "123456") {
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
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    


}



extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
