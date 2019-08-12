//
//  Card.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/11/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

class Card: UIView {
    var photoImageView = UIImageView()
    var usernameLbl = UILabel()
    var locationLbl = UILabel()
    var infoButton = UIButton()
    var controller: RadarViewController!
    
    var user: User! {
        didSet {
            photoImageView.loadImage(user.profileImageUrl) { (image) in
                self.user.profileImage = image
            }
            
            let attributedUsernameText = NSMutableAttributedString(string: "\(user.username)  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
                                                                                                              NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
            var age = ""
            if let ageValue = user.age {
                age = String(ageValue)
            }
            let attributedAgeText = NSMutableAttributedString(string: age, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22),
                                                                                        NSAttributedString.Key.foregroundColor : UIColor.white                                                                     ])
            attributedUsernameText.append(attributedAgeText)
            
            usernameLbl.attributedText = attributedUsernameText
            
            if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String, let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
                let currentLocation:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
                if !user.latitude.isEmpty && !user.longitude.isEmpty {
                    
                    let userLoc = CLLocation(latitude: Double(user.latitude)! , longitude: Double(user.longitude)!)
                    let distanceInKM: CLLocationDistance = userLoc.distance(from: currentLocation) / 1000
                    // let kmIntoMiles = distanceInKM * 0.6214
                    locationLbl.text = "\(Int(distanceInKM)) Km away"
                } else {
                    locationLbl.text = ""
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        setupPhotoImageView()
        setupUsernameLbl()
        setupLocationLbl()
        setupInfoBtn()
    }
    
    func setupPhotoImageView() {
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        photoImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
        addSubview(photoImageView)
    }
    
    func setupUsernameLbl() {
        usernameLbl.textColor = .white
        usernameLbl.font = .systemFont(ofSize: 20)
        addSubview(usernameLbl)
    }
    
    func setupLocationLbl() {
        locationLbl.textColor = .white
        locationLbl.font = .systemFont(ofSize: 20)
        addSubview(locationLbl)
    }
    
    func setupInfoBtn() {
        infoButton.setImage(UIImage(named: "info_icon"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonDidTaped), for: .touchUpInside)
        addSubview(infoButton)
    }
    
    func createConstraints() {
        photoImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        locationLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        usernameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(locationLbl)
            make.bottom.equalTo(locationLbl.snp.top).offset(-5)
        }
        infoButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-20)
            make.height.width.equalTo(32)
        }
    }
    @objc func infoButtonDidTaped() {
        let detailVc = DetailViewController()
        detailVc.user = user
        controller.navigationController?.pushViewController(detailVc, animated: true)
    }
}
