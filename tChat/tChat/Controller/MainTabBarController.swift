//
//  MainTabBarController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import FirebaseAuth
import SnapKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        
//        let usersVC = UINavigationController(rootViewController: PeopleViewController())
//        usersVC.tabBarItem.title = "Users"
//        usersVC.tabBarItem.image = UIImage(named: "icon_users")
        
        let radarVC = UINavigationController(rootViewController: RadarViewController())
        radarVC.tabBarItem.image = UIImage(named: "icon-radar")
        
        let messagesVC = UINavigationController(rootViewController: MessagesViewController())
        messagesVC.tabBarItem.title = "Messages"
        messagesVC.tabBarItem.image = UIImage(named: "icon_messages")
    
        
        let meVC = UINavigationController(rootViewController: ProfileViewController())
        meVC.tabBarItem.title = "Me"
        meVC.tabBarItem.image = UIImage(named: "icon_profile")
        
        viewControllers = [meVC, radarVC, messagesVC]
//        tabBarController?.selectedViewController = radarVC
        self.selectedIndex = 1

        
    }
//    
//    @objc func logoutDidTaped() {
//        print("logout")
//    }
}
