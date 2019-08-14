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
import EZSwipeController

class MainSwipeController: EZSwipeController {
    
    override func setupView() {
        datasource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}


extension MainSwipeController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        let radarVC = RadarViewController()
        
        let meVC = ProfileViewController()
        
        let messagesVC = MessagesViewController()
        
        return [meVC, radarVC, messagesVC]
    }
    
    func indexOfStartingPage() -> Int {
        return 1
    }
    
    func navigationBarDataForPageIndex(_ index: Int) -> UINavigationBar {
        
        let navigationBar = UINavigationBar()
        navigationBar.barStyle = UIBarStyle.default
        navigationBar.barTintColor = .white
        
        let navigationItem = UINavigationItem()
        navigationItem.hidesBackButton = true

        let radarImg = UIImage(named: "icon-radar")
        
        let messagesImg = UIImage(named: "icon_messages")
        
        let profileImg = UIImage(named: "icon_profile")

        let rightButtonItem = UIBarButtonItem(image: messagesImg, style: .plain, target: self, action: #selector(moveToMessagesVC))
        
        let leftButtonItem = UIBarButtonItem(image: profileImg, style: .plain, target: self, action: #selector(moveToMeVC))
        
        let radarBtn = UIButton()
        radarBtn.setImage(radarImg, for: .normal)
        radarBtn.addTarget(self, action: #selector(moveToRadarVC), for: .touchUpInside)
        
        
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.titleView = radarBtn
        
        navigationBar.pushItem(navigationItem, animated: false)
        return navigationBar
    }
    
    @objc func moveToMeVC() {
        self.moveToPage(0, animated: true)
    }
    
    @objc func moveToRadarVC() {
        self.moveToPage(1, animated: true)
    }
    
    @objc func moveToMessagesVC() {
        self.moveToPage(2, animated: true)
    }
    
}
