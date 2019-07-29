//
//  EXT-SignUpViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/28/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SnapKit

extension SignUpViewController {
    
    func setupCloseBtn() {
        closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(moveBackToWelcomePage), for: .touchUpInside)
        view.addSubview(closeBtn)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        let title = "Sign Up"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        view.addSubview(titleLabel)
    }
    
    func setupAvatar() {
        avatar = UIImageView()
        avatar.image = UIImage()
        avatar.backgroundColor = .gray
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        view.addSubview(avatar)
    }
    
    func setupWrapperViewForFullName() {
        wrapperViewForFullName = UIView()
        wrapperViewForFullName.layer.borderWidth = 1
        wrapperViewForFullName.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        wrapperViewForFullName.layer.cornerRadius = 3
        wrapperViewForFullName.clipsToBounds = true
        view.addSubview(wrapperViewForFullName)
    }
    
    func setupFullNameTextField() {
        fullNameTextField = UITextField()
        fullNameTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        fullNameTextField.attributedPlaceholder = placeholderAttr
        fullNameTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        wrapperViewForFullName.addSubview(fullNameTextField)
    }
    
    func setupWrapperViewForEmail() {
        wrapperViewForEmail = UIView()
        wrapperViewForEmail.layer.borderWidth = 1
        wrapperViewForEmail.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        wrapperViewForEmail.layer.cornerRadius = 3
        wrapperViewForEmail.clipsToBounds = true
        view.addSubview(wrapperViewForEmail)
    }
    
    func setupEmailAddressTextField() {
        emailAddressTextField = UITextField()
        emailAddressTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        emailAddressTextField.attributedPlaceholder = placeholderAttr
        emailAddressTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        wrapperViewForEmail.addSubview(emailAddressTextField)
    }
    
    func setupWrapperViewForPassword() {
        wrapperViewForPassword = UIView()
        wrapperViewForPassword.layer.borderWidth = 1
        wrapperViewForPassword.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        wrapperViewForPassword.layer.cornerRadius = 3
        wrapperViewForPassword.clipsToBounds = true
        view.addSubview(wrapperViewForPassword)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Password( 8+ Characters)", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        passwordTextField.attributedPlaceholder = placeholderAttr
        passwordTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        passwordTextField.isSecureTextEntry = true
        wrapperViewForPassword.addSubview(passwordTextField)
    }
    
    func setupSignUpBtn() {
        signUpBtn = UIButton()
        signUpBtn.backgroundColor = .black
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpBtn.layer.cornerRadius = 5
        signUpBtn.clipsToBounds = true
        signUpBtn.addTarget(self, action: #selector(signUpDidTaped), for: .touchUpInside)
        view.addSubview(signUpBtn)
    }
    
    func setupAlreadyHaveAccountBtn() {
        alreadyHaveAccountBtn = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        let attributedSubText = NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        attributedText.append(attributedSubText)
        alreadyHaveAccountBtn.setAttributedTitle(attributedText, for: .normal)
        alreadyHaveAccountBtn.addTarget(self, action: #selector(moveToSignInPage), for: .touchUpInside)
        view.addSubview(alreadyHaveAccountBtn)
    }
    
    @objc func moveToSignInPage() {
        let signInPage = SignInViewController()
//        present(signInPage, animated: true, completion: nil)
        navigationController?.pushViewController(signInPage, animated: true)
    }
    
    @objc func moveBackToWelcomePage() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK - Actions
    @objc func signUpDidTaped() {
        print("Hey")
        
        guard let email = emailAddressTextField.text else {
            return
        }
        print("Email")
        
        guard let password = passwordTextField.text else {
            return
        }
        
        print("Password")
        
        guard let fullName = fullNameTextField.text else {
            return
        }
        
        print("Full Name")
        
        guard let selectedImage = avatar.image else {
            print("Avatar is nil")
            return
        }
        
        print("Image")
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        print("Image Data")
        
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (authDataRes, err) in
            if err != nil {
                print(err?.localizedDescription)
                return
            }
            if let userData = authDataRes {
                var dict: Dictionary<String, Any> = [
                    "uid"             : userData.user.uid,
                    "email"           : userData.user.email,
                    "fullName"        : fullName,
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
