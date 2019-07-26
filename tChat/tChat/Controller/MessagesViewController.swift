//
//  MessagesViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class MessagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let btn = UIButton()
        btn.setTitle("logout", for: .normal)
        btn.backgroundColor = .red
        view.addSubview(btn)
        btn.snp.makeConstraints {
            (make) in
            make.left.right.equalToSuperview().offset(50)
            make.topMargin.equalToSuperview().offset(100)
            make.height.equalTo(40)
        }
        btn.addTarget(self, action: Selector("logoutBtnDidTaped"), for: .touchUpInside)
        
    }
    
    @objc func logoutBtnDidTaped() {
        print("Tapped")
        do {
            try Auth.auth().signOut()
        }
        catch let err {
            print(err)
        }
    }
  
}
