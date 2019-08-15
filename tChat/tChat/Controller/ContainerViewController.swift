//
//  ContainerViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/15/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit

class ContainerViewController: UIViewController {
    var items = [UIImage(named: "icon-radar"), UIImage(named: "icon-radar")]
    lazy var segmentedControl: TinderLikeSegmentedControl = {
        var control = TinderLikeSegmentedControl(items: items)
        control.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(switchTabs), for: .valueChanged)
        return control
    }()
    var contentView = UIView()
    var currentViewController: UIViewController?
    
    var radarTabVC = RadarViewController()
    var myLikesTabVC = MyLikesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        createConstaints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    @objc func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func setupViews() {
        displayCurrentTab(segmentedControl.selectedSegmentIndex)
        self.navigationItem.titleView = segmentedControl
        self.view.addSubview(contentView)
    }
    
    func createConstaints() {
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case 0 :
            vc = radarTabVC
        case 1 :
            vc = myLikesTabVC
        default:
            return nil
        }
        return vc
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
}
