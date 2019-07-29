//
//  SignInViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SnapKit

class SignInViewController: UIViewController {
    
    var titleLabel: UILabel!
    var wrapperViewForEmail: UIView!
    var emailAddressTextField: UITextField!
    var wrapperViewForPassword: UIView!
    var passwordTextField: UITextField!
    var signInBtn: UIButton!
    var dontHaveAccountBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        makeConstraints()
        signInDidTaped()
        
        
    }
    
    func setupViews() {
        setupTitleLabel()
        setupWrapperViewForEmail()
        setupEmailAddressTextField()
        setupWrapperViewForPassword()
        setupPasswordTextField()
        setupSignInBtn()
        setupDontHaveAccountBtn()
        
    }
    
    func constraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    func constraintsForWrapperViewEmail() {
        wrapperViewForEmail.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
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
    
    func constraintsForSignInBtn() {
        signInBtn.snp.makeConstraints {
            (make) in
            make.top.equalTo(wrapperViewForPassword.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func constraintsForDontHaveAccountBtn() {
        dontHaveAccountBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signInBtn.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    
    func makeConstraints() {
        constraintsForTitleLabel()
        constraintsForWrapperViewEmail()
        constraintsForEmailAddressTextField()
        constraintsForWrapperViewPassword()
        constraintsForPasswordTextField()
        constraintsForSignInBtn()
        constraintsForDontHaveAccountBtn()
    }
    
    
    //MARK - Actions
    func signInDidTaped() {
        Auth.auth().signIn(withEmail: "aibolseed@gmail.com", password: "7kPwWCD33CyQdih") {
            (authData, err) in
            if err != nil {
                print(err)
                return
            }
            print("Authenticated")
        }
    }
    
    

}
