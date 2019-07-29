//
//  ResetPasswordViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    var closeBtn: UIButton!
    var wrapperViewForEmail: UIView!
    var emailAddressTextField: UITextField!
    var resetPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        makeConstraints()
        
    }
    
    func setupViews() {
        setupCloseBtn()
        setupWrapperViewForEmail()
        setupEmailAddressTextField()
        setupResetPasswordBtn()
    }
    
    func constraintsForCloseBtn() {
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    func constraintsForWrapperViewEmail() {
        wrapperViewForEmail.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom).offset(40)
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
    
    func constraintsForResetPasswordBtn() {
        resetPasswordBtn.snp.makeConstraints {
            (make) in
            make.top.equalTo(wrapperViewForEmail.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func makeConstraints() {
        constraintsForCloseBtn()
        constraintsForWrapperViewEmail()
        constraintsForEmailAddressTextField()
        constraintsForResetPasswordBtn()
    }
    
    
    

    func resetPasswordBtnDidTaped() {
        Auth.auth().sendPasswordReset(withEmail: "aibolseed@gmail.com") {
            (err) in
            if err != nil {
                print(err)
                return
            }
            print("Send!")
        }
    }

}
