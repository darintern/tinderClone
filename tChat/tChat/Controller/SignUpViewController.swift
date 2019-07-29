//
//  ViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import ProgressHUD

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
    var image = UIImage(named: "Aibol")
    
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
    
    @objc func signUpDidTaped() {
        self.view.endEditing(true)
        self.validateFields()
        self.signUp(onSuccess: {
            // switch view
            (UIApplication.shared.delegate as! AppDelegate).confugureInitialViewController()
        }) { (errorMessage) in            
            ProgressHUD.showError(errorMessage)
        }
    }
}

