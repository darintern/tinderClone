//
//  UsersAroundViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/7/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

class UsersAroundViewController: UIViewController {
    var slider = UISlider()
    var distanceLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        setupSlider()
        setupDistanceLabel()
        title = "Find Users"
        self.navigationItem.titleView = slider
        let refresh = UIBarButtonItem(image: UIImage(named: "icon-refresh"), style: .plain, target: self, action: #selector(refreshDidTaped))
        self.navigationItem.rightBarButtonItems = [refresh, UIBarButtonItem(customView: distanceLabel)]
    }
    
    func setupSlider() {
        slider.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        slider.minimumValue = 1
        slider.maximumValue = 999
        slider.value = Float(50)
        slider.isContinuous = true
        slider.tintColor = UIColor.rgbColor(r: 93, g: 79, b: 141, alpha: 1)
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: .valueChanged)
    }
    
    func setupDistanceLabel() {
        distanceLabel.text = String(500)
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.textColor = UIColor.rgbColor(r: 93, g: 79, b: 141, alpha: 1)
    }

    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
        
    }
    
    @objc func refreshDidTaped() {
        
    }
    
}
