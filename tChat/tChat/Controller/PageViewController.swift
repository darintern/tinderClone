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

class PageViewController: UIViewController {
    private var pageController: UIPageViewController?
    private var scrollView: UIScrollView?
    private var images = ["icon_users", "icon_messages", "icon-radar"]
    private var controllers = [ProfileViewController(), MessagesViewController(), RadarViewController()]
    private var currentIndex: Int = 1
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar()
        setupPageController()
        scrollView?.isPagingEnabled = true
        
    }
    
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        self.pageController?.didMove(toParent: self)
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

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return ProfileViewController()
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return MessagesViewController()
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.images.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}
