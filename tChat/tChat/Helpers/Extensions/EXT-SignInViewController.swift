//
//  EXT-SignInViewController.swift
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

extension SignInViewController {
    func setupTitleLabel() {
        titleLabel = UILabel()
        let title = "Sign In"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        view.addSubview(titleLabel)
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
    
    func setupSignInBtn() {
        signInBtn = UIButton()
        signInBtn.backgroundColor = .black
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInBtn.layer.cornerRadius = 5
        signInBtn.clipsToBounds = true
        signInBtn.addTarget(self, action: #selector(signInDidTaped), for: .touchUpInside)
        view.addSubview(signInBtn)
    }
    
    func setupDontHaveAccountBtn() {
        dontHaveAccountBtn = UIButton()
        let attributedText = NSMutableAttributedString(string: "Dont't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        let attributedSubText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        attributedText.append(attributedSubText)
        dontHaveAccountBtn.setAttributedTitle(attributedText, for: .normal)
        dontHaveAccountBtn.addTarget(self, action: #selector(moveToSignUpPage), for: .touchUpInside)
        view.addSubview(dontHaveAccountBtn)
    }
    
    func setupForgotPasswordBtn() {
        forgotPasswordBtn = UIButton()
        forgotPasswordBtn.setTitle("Forgot Password ?", for: .normal)
        forgotPasswordBtn.setTitleColor(.black, for: .normal)
        forgotPasswordBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        forgotPasswordBtn.layer.cornerRadius = 5
        forgotPasswordBtn.clipsToBounds = true
        forgotPasswordBtn.addTarget(self, action: #selector(moveToResetPasswordPage), for: .touchUpInside)
        view.addSubview(forgotPasswordBtn)
    }
    
    @objc func moveToResetPasswordPage() {
        let resetPasswordPage = ResetPasswordViewController()
        navigationController?.pushViewController(resetPasswordPage , animated: true)
    }
    
    @objc func moveToSignUpPage() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK - Actions
    @objc func signInDidTaped() {
        guard let email = emailAddressTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (authData, err) in
            if err != nil {
                print(err)
                return
            }
            print("Authenticated")
        }
    }
    
}
