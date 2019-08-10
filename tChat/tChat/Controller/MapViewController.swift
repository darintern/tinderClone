//
//  MapViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/10/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    var map = MKMapView()
    var backBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews() {
        setupMap()
        setupBackBtn()
    }
    
    func setupBackBtn() {
        backBtn.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnDidTaped), for: .touchUpInside)
        backBtn.tintColor = PURPLE_COLOR
        view.addSubview(backBtn)
    }
    
    func setupMap() {
        view.addSubview(map)
    }
    
    func createConstraints() {
        map.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    @objc func backBtnDidTaped() {
        navigationController?.popViewController(animated: true)
    }
}

