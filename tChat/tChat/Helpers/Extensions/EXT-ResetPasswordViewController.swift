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
        wrapperViewForEmail.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210, alpha: 1).cgColor
        wrapperViewForEmail.layer.cornerRadius = 3
        wrapperViewForEmail.clipsToBounds = true
        view.addSubview(wrapperViewForEmail)
    }
    
    func setupEmailAddressTextField() {
        emailAddressTextField = UITextField()
        emailAddressTextField.autocapitalizationType = .none
        emailAddressTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgbColor(r: 170, g: 170, b: 170, alpha: 1)])
        emailAddressTextField.attributedPlaceholder = placeholderAttr
        emailAddressTextField.textColor = UIColor.rgbColor(r: 99, g: 99, b: 99, alpha: 1)
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
        guard let email = emailAddressTextField.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
            return
        }
        self.resetPassword(onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess(SUCCESS_EMAIL_RESET)
            self.navigationController?.popViewController(animated: true)
            // switch view
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
}
