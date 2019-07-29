//
//  EXT-WelcomeViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/28/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

extension WelcomeViewController {
    
    func setupHeaderTitle() {
        titleLabel = UILabel()
        let title = "Create new account"
        let subTitle = "\n subtitle"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
        let attributedSubtitle = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.45) ])
        attributedText.append(attributedSubtitle)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        titleLabel.numberOfLines = 0
        
        
        titleLabel.attributedText = attributedText
        view.addSubview(titleLabel)
    }
    
    func setupSignInFacebookBtn() {
        signInFacebookBtn = UIButton()
        let origFacebookImage = UIImage(named: "icon-facebook")
        let tintedFacebookImage = origFacebookImage?.withRenderingMode(.alwaysTemplate)
        
        signInFacebookBtn.setTitle("Sign in with Facebook", for: .normal)
        signInFacebookBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInFacebookBtn.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        signInFacebookBtn.layer.cornerRadius = 5
        signInFacebookBtn.clipsToBounds = true
        signInFacebookBtn.setImage(tintedFacebookImage, for: .normal)
        signInFacebookBtn.imageView?.contentMode = .scaleAspectFit
        signInFacebookBtn.tintColor = .white
        signInFacebookBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        view.addSubview(signInFacebookBtn)
    }
    
    func setupSignInGoogleBtn() {
        signInGoogleBtn = UIButton()
        signInGoogleBtn.setTitle("Sign in with Google", for: .normal)
        signInGoogleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInGoogleBtn.layer.cornerRadius = 5
        signInGoogleBtn.imageView?.contentMode = .scaleAspectFit
        signInGoogleBtn.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1)
        signInGoogleBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -35, bottom: 12, right: 0)
        signInGoogleBtn.tintColor = .white
        signInGoogleBtn.clipsToBounds = true
        signInGoogleBtn.setImage(UIImage(named: "icon-google"), for: .normal)
        view.addSubview(signInGoogleBtn)
    }
    
    func setupOrLabel() {
        orLabel = UILabel()
        orLabel.text = "or"
        orLabel.textAlignment = .center
        orLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orLabel.textColor = UIColor.init(white: 0, alpha: 0.45)
        view.addSubview(orLabel)
    }
    
    func setupCreateNewAccountBtn() {
        createAccountBtn = UIButton()
        createAccountBtn.setTitle("Create a new account", for: .normal)
        createAccountBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createAccountBtn.layer.cornerRadius = 5
        createAccountBtn.backgroundColor = .black
        createAccountBtn.clipsToBounds = true
        createAccountBtn.addTarget(self, action: Selector("moveToSignUpPage"), for: .touchUpInside)
        view.addSubview(createAccountBtn)
    }
    
    func setupTermsOfServiceLabel() {
        termsOfServiceLabel = UILabel()
        let attributedTermsText = NSMutableAttributedString(string: "By clicking \"Create new account\" you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        let attributedSubTermsText = NSMutableAttributedString(string: "Terms of Service", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        attributedTermsText.append(attributedSubTermsText)
        
        
        termsOfServiceLabel.attributedText = attributedTermsText
        termsOfServiceLabel.numberOfLines = 0
        view.addSubview(termsOfServiceLabel)
    }
    
    func createConstraints() {
        constraintsForTitleLabel()
        constraintsForSignInFacebookBtn()
        constraintsForSignInGoogleBtn()
        constraintsForOrLabel()
        constraintsForCreateAccountBtn()
        constraintsForTermsLabel()
    }
    func constraintsForTitleLabel() {
        titleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func constraintsForSignInFacebookBtn() {
        signInFacebookBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            //            make.top.equalTo(.snp.bottom).offset(40)
        }
    }
    
    func constraintsForSignInGoogleBtn() {
        signInGoogleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signInFacebookBtn.snp.bottom).offset(25)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func constraintsForOrLabel() {
        orLabel.snp.makeConstraints { (make) in
            make.top.equalTo(signInGoogleBtn.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
        }
    }
    
    func constraintsForCreateAccountBtn() {
        createAccountBtn.snp.makeConstraints { (make) in
            make.top.equalTo(orLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func constraintsForTermsLabel() {
        termsOfServiceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(createAccountBtn.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    
    @objc func moveToSignUpPage() {
        let signUpPage = SignUpViewController()
//        present(signUpPage, animated: true, completion: nil)
        navigationController?.pushViewController(signUpPage, animated: true)
    }
}
