//
//  EXT-ResetPasswordViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/28/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

extension ResetPasswordViewController {
    func setupCloseBtn() {
        closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(moveBackToSignInPage), for: .touchUpInside)
        view.addSubview(closeBtn)
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
    
    func setupResetPasswordBtn() {
        resetPasswordBtn = UIButton()
        resetPasswordBtn.backgroundColor = .black
        resetPasswordBtn.setTitle("RESET MY PASSWORD", for: .normal)
        resetPasswordBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        resetPasswordBtn.layer.cornerRadius = 5
        resetPasswordBtn.clipsToBounds = true
        resetPasswordBtn.addTarget(self, action: #selector(resetPasswordBtnDidTaped), for: .touchUpInside)
        view.addSubview(resetPasswordBtn)
    }
    
    @objc func moveBackToSignInPage() {
        navigationController?.popViewController(animated: true)
    }
    
    func resetPassword(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show()
        Api.User.resetPassword(with: emailAddressTextField.text!, onSuccess: {
            ProgressHUD.dismiss()
            onSuccess()
        }) { (error) in
            onError(error)
        }
    }
    
    @objc func resetPasswordBtnDidTaped() {
        guard emailAddressTextField.text != nil else {
            return
        }
        self.resetPassword(onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess("Send")
            self.navigationController?.popViewController(animated: true)
            // switch view
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
}
