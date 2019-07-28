//
//  WelcomeViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/28/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    var titleLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    var signInFacebookBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign in with Facebook", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        return btn
    }()
    var signInGoogleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign in with Google", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        return btn
    }()
    var createAccountBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create a new account", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        return btn
    }()
    var termsOfServiceLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    var orLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createConstraints()
    }
    
    func setupUI() {
        view.backgroundColor = .white
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
        
        orLabel.text = "or"
        orLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orLabel.textColor = UIColor.init(white: 0, alpha: 0.45)
        
        let attributedTermsText = NSMutableAttributedString(string: "By clicking \"Create new account\" you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        let attributedSubTermsText = NSMutableAttributedString(string: "Terms of Service", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        attributedTermsText.append(attributedSubTermsText)
        
        
        termsOfServiceLabel.attributedText = attributedTermsText
        termsOfServiceLabel.numberOfLines = 0
        
        
        view.addSubview(titleLabel)
        view.addSubview(signInGoogleBtn)
        view.addSubview(signInFacebookBtn)
        view.addSubview(createAccountBtn)
        view.addSubview(termsOfServiceLabel)
        view.addSubview(orLabel)
        
    }
    
    func createConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        signInFacebookBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
//            make.top.equalTo(.snp.bottom).offset(40)
        }
        signInGoogleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signInFacebookBtn.snp.bottom).offset(25)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        orLabel.snp.makeConstraints { (make) in
            make.top.equalTo(signInGoogleBtn.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
        }
        createAccountBtn.snp.makeConstraints { (make) in
            make.top.equalTo(orLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        termsOfServiceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(createAccountBtn.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
