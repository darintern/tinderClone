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

class MainController: UIViewController {
    var scrollView = UIScrollView()
    private var lastContentOffset: CGFloat = 0
    static let shared = MainController()
    private var controllers = [ProfileViewController(), RadarViewController(), MessagesViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupSlideScrollView()
        self.view.addSubview(scrollView)
        
        let imageView = UIImageView()
        let radarImg = UIImage(named: "icon_top")?.withRenderingMode(.alwaysOriginal)
        imageView.image = radarImg
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToRadarPage)))
        imageView.isUserInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_messages"), style: .plain, target: self, action: #selector(moveToMessagesPage))
        self.navigationItem.titleView = imageView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_profile"), style: .plain, target: self, action: #selector(moveToProfilePage))
//        self.navigationController?.setViewControllers(controllers, animated: true)
//        for i in 0 ..< controllers.count {
//            self.addChild(controllers[i])
//        }
        createConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moveToRadarPage()
    }
    
    func createConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    func setupSlideScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(controllers.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< controllers.count {
            controllers[i].view.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(controllers[i].view)
            
        }
    }
    
    @objc func moveToMessagesPage() {
        scrollView.setContentOffset(CGPoint(x: view.frame.width * 2, y: 0), animated: true)
    }
    
    @objc func moveToProfilePage() {
        scrollView.setContentOffset(CGPoint(x: view.frame.width * 0, y: 0), animated: true)
    }
    
    @objc func moveToRadarPage() {
        scrollView.setContentOffset(CGPoint(x: view.frame.width * 1, y: 0), animated: true)
    }
    
    
//    func setupTabBar() {
//
////        let usersVC = UINavigationController(rootViewController: PeopleViewController())
////        usersVC.tabBarItem.title = "Users"
////        usersVC.tabBarItem.image = UIImage(named: "icon_users")
//
//        let radarVC = UINavigationController(rootViewController: RadarViewController())
//        radarVC.tabBarItem.image = UIImage(named: "icon-radar")
//
//        let messagesVC = UINavigationController(rootViewController: MessagesViewController())
//        messagesVC.tabBarItem.title = "Messages"
//        messagesVC.tabBarItem.image = UIImage(named: "icon_messages")
//
//
//        let meVC = UINavigationController(rootViewController: ProfileViewController())
//        meVC.tabBarItem.title = "Me"
//        meVC.tabBarItem.image = UIImage(named: "icon_profile")
//
//        viewControllers = [meVC, radarVC, messagesVC]
////        tabBarController?.selectedViewController = radarVC
//        self.selectedIndex = 1
//
//
//    }

}

extension MainController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
