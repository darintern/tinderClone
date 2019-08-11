//
//  EXT-WelcomeViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/28/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ProgressHUD
import Firebase
import GoogleSignIn

extension WelcomeViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
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
        signInFacebookBtn.backgroundColor = UIColor.rgbColor(r: 58, g: 85, b: 159, alpha: 1)
        signInFacebookBtn.layer.cornerRadius = 5
        signInFacebookBtn.clipsToBounds = true
        signInFacebookBtn.setImage(tintedFacebookImage, for: .normal)
        signInFacebookBtn.imageView?.contentMode = .scaleAspectFit
        signInFacebookBtn.tintColor = .white
        signInFacebookBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        
        signInFacebookBtn.addTarget(self, action: #selector(facebookBtnDidTaped), for: .touchUpInside)
        view.addSubview(signInFacebookBtn)
    }
    
    func setupSignInGoogleBtn() {
        signInGoogleBtn = UIButton()
        signInGoogleBtn.setTitle("Sign in with Google", for: .normal)
        signInGoogleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        signInGoogleBtn.layer.cornerRadius = 5
        signInGoogleBtn.imageView?.contentMode = .scaleAspectFit
        signInGoogleBtn.backgroundColor = UIColor.rgbColor(r: 223, g: 74, b: 50, alpha: 1)
        signInGoogleBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: -35, bottom: 12, right: 0)
        signInGoogleBtn.tintColor = .white
        signInGoogleBtn.clipsToBounds = true
        signInGoogleBtn.setImage(UIImage(named: "icon-google"), for: .normal)
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        signInGoogleBtn.addTarget(self, action: #selector(googleBtnDidTaped), for: .touchUpInside)
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
        createAccountBtn.addTarget(self, action: #selector(moveToSignUpPage), for: .touchUpInside)
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
        navigationController?.pushViewController(signUpPage, animated: true)
    }
    
    @objc func facebookBtnDidTaped() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_porfile", "email"], from: self) { (result, error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                if let error = error {
                    ProgressHUD.showError(error.localizedDescription)
                }
                if let userData = result {
                    self.handleFbGoogleLogic(userData: userData)
                }
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            }
            if let userData = result {
                self.handleFbGoogleLogic(userData: userData)
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        ProgressHUD.showError(error.localizedDescription)
    }
    
    @objc func googleBtnDidTaped() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func handleFbGoogleLogic(userData: AuthDataResult) {
        let dict: Dictionary<String, Any> = [
            UID               : userData.user.uid,
            EMAIL             : userData.user.email,
            USERNAME          : userData.user.displayName,
            PROFILE_IMAGE_URL : (userData.user.photoURL == nil ) ? "" : userData.user.photoURL!.absoluteString,
            STATUS            : "Welcome to Tinder"
        ]
        Ref().databaseSpecificUser(uid: userData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                Api.User.isOnline(bool: true)
                (UIApplication.shared.delegate as! AppDelegate).confugureInitialViewController()
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        })
    }
}
