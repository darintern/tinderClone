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

    override func viewDidLoad() {
        super.viewDidLoad()
        signInDidTaped()
        
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