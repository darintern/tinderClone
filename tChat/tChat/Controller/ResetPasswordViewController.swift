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

    override func viewDidLoad() {
        super.viewDidLoad()
        resetPasswordBtnDidTaped()
        
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
