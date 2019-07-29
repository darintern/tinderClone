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

    var titleLabel: UILabel!
    var signInFacebookBtn: UIButton!
    var signInGoogleBtn: UIButton!
    var createAccountBtn: UIButton!
    var termsOfServiceLabel: UILabel!
    var orLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        createConstraints()
    }
    
    func setupUI() {
        setupHeaderTitle()
        setupSignInFacebookBtn()
        setupSignInGoogleBtn()
        setupOrLabel()
        setupCreateNewAccountBtn()
        setupTermsOfServiceLabel()
    }
    
    
}
