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
    var likeView = UIView()
    var likeLabel = UILabel()
    var nopeView = UIView()
    var nopeLabel = UILabel()
    var controller: RadarViewController!
    
    var user: User! {
        didSet {
            photoImageView.loadImage(user.profileImageUrl)
            if let image = photoImageView.image {
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
        setupLikeView()
        setupNopeView()
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
    
    func setupLikeView() {
        likeView.layer.borderWidth = 3
        likeView.layer.cornerRadius = 5
        likeView.clipsToBounds = true
        likeView.backgroundColor = .white
        likeView.layer.borderColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1).cgColor
        likeView.transform = CGAffineTransform(rotationAngle: -.pi/8)
        likeView.alpha = 0
        addSubview(likeView)
        likeLabel.addCharacterSpacing()
        likeLabel.attributedText = NSAttributedString(string: "LIKE", attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 45)])
        likeLabel.textColor = UIColor(red: 0.101, green: 0.737, blue: 0.611, alpha: 1)
        likeView.addSubview(likeLabel)
    }
    
    func setupNopeView() {
        nopeView.layer.borderWidth = 3
        nopeView.layer.cornerRadius = 5
        nopeView.clipsToBounds = true
        nopeView.backgroundColor = .white
        nopeView.transform = CGAffineTransform(rotationAngle: .pi/8)
        nopeView.alpha = 0
        nopeView.layer.borderColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1).cgColor
        addSubview(nopeView)
        nopeLabel.addCharacterSpacing()
        nopeLabel.attributedText = NSAttributedString(string: "NOPE", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 45)])
        nopeLabel.textColor = UIColor(red: 0.9, green: 0.29, blue: 0.23, alpha: 1)
        nopeView.addSubview(nopeLabel)
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
        likeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }
        likeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        nopeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        nopeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
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
