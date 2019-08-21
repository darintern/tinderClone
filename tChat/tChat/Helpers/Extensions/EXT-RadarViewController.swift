//
//  EXT-RadarViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/19/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GeoFire
import ProgressHUD


// MARK: Extension for setupViews
extension RadarViewController {
    func setupCardStack() {
        view.addSubview(cardStack)
    }
    
    func setupRefreshImageView() {
        refreshImageView.image = UIImage(named: "refresh_circle")
        refreshImageView.contentMode = .scaleAspectFit
        refreshImageView.isUserInteractionEnabled = true
        bottomStackView.addArrangedSubview(refreshImageView)
    }
    
    func setupNopeImageView() {
        nopeImageView.image = UIImage(named: "nope_circle")
        nopeImageView.contentMode = .scaleAspectFit
        nopeImageView.isUserInteractionEnabled = true
        let nopeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nopeDidTaped))
        nopeImageView.addGestureRecognizer(nopeTapGestureRecognizer)
        bottomStackView.addArrangedSubview(nopeImageView)
    }
    
    func setupSuperLikeImageView() {
        superLikeImageView.image = UIImage(named: "super_like_circle")
        superLikeImageView.contentMode = .scaleAspectFit
        superLikeImageView.isUserInteractionEnabled = true
        bottomStackView.addArrangedSubview(superLikeImageView)
    }
    
    func setupLikeImageView() {
        likeImageView.image = UIImage(named: "like_circle")
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.isUserInteractionEnabled = true
        let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeDidTaped))
        likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
        bottomStackView.addArrangedSubview(likeImageView)
    }
    
    func setupBoostImageView() {
        boostImageView.image = UIImage(named: "boost_circle")
        boostImageView.contentMode = .scaleAspectFit
        boostImageView.isUserInteractionEnabled = true
        bottomStackView.addArrangedSubview(boostImageView)
    }
    
    func setupBottomStackView() {
        bottomStackView.distribution = .fillEqually
        bottomStackView.axis = .horizontal
        view.addSubview(bottomStackView)
        setupRefreshImageView()
        setupNopeImageView()
        setupLikeImageView()
        setupSuperLikeImageView()
        setupBoostImageView()
    }
    
    func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        blurEffectView.alpha = 0
        blurEffectView.isHidden = true
        setupWrapperForText()
        setupSendMsgBtn()
        setupKeepSwipingBtn()
        setupPartnerMatchImageView()
        setupMyMatchImageView()
    }
    
    func setupSendMsgBtn() {
        sendMsgBtn.setAttributedTitle(NSAttributedString(string: "SEND MESSAGE", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
        sendMsgBtn.layer.borderColor = PURPLE_COLOR.cgColor
        sendMsgBtn.backgroundColor = PURPLE_COLOR
        sendMsgBtn.layer.borderWidth = 2
        sendMsgBtn.layer.cornerRadius = 23
        sendMsgBtn.clipsToBounds = true
        sendMsgBtn.addTarget(self, action: #selector(moveToPartnerChat), for: .touchUpInside)
        blurEffectView.contentView.addSubview(sendMsgBtn)
    }
    
    func setupKeepSwipingBtn() {
        keepSwipingBtn.setAttributedTitle(NSAttributedString(string: "Keep Swiping", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
        keepSwipingBtn.layer.borderColor = PURPLE_COLOR.cgColor
        keepSwipingBtn.backgroundColor = .clear
        keepSwipingBtn.layer.borderWidth = 2
        keepSwipingBtn.layer.cornerRadius = 23
        keepSwipingBtn.clipsToBounds = true
        keepSwipingBtn.addTarget(self, action: #selector(dissmissblur), for: .touchUpInside)
        blurEffectView.contentView.addSubview(keepSwipingBtn)
    }
    
    func setupPartnerMatchImageView() {
        partnerMatchImageView.image = UIImage(named: "Aibol")
        partnerMatchImageView.contentMode = .scaleAspectFill
        partnerMatchImageView.layer.cornerRadius = 55
        partnerMatchImageView.layer.borderWidth = 2
        partnerMatchImageView.layer.borderColor = UIColor.white.cgColor
        partnerMatchImageView.clipsToBounds = true
        blurEffectView.contentView.addSubview(partnerMatchImageView)
    }
    
    func setupMyMatchImageView() {
        myMatchImageView.image = UIImage(named: "taylor_swift")
        myMatchImageView.contentMode = .scaleAspectFill
        myMatchImageView.layer.cornerRadius = 55
        myMatchImageView.layer.borderWidth = 2
        myMatchImageView.layer.borderColor = UIColor.white.cgColor
        myMatchImageView.clipsToBounds = true
        blurEffectView.contentView.addSubview(myMatchImageView)
    }
    
    func setupWrapperForText() {
        blurEffectView.contentView.addSubview(wrapperForText)
        setupTitleTextLbl()
        setupSubTextLbl()
    }
    
    func setupTitleTextLbl() {
        titleTextLabel.text = "It's a Match"
        titleTextLabel.textAlignment = .center
        titleTextLabel.textColor = .white
        titleTextLabel.font = UIFont(name: Fonts.hipster, size: 60)
        wrapperForText.addSubview(titleTextLabel)
    }
    
    func setupSubTextLbl() {
        subTextLbl.text = "You and Kelly Kurk have liked each other"
        subTextLbl.lineBreakMode = .byWordWrapping
        subTextLbl.font = .systemFont(ofSize: 14)
        subTextLbl.textColor = .white
        subTextLbl.textAlignment = .center
        subTextLbl.numberOfLines = 0
        wrapperForText.addSubview(subTextLbl)
    }
}


// MARK: Extension for create constraints
extension RadarViewController {
    func createConstraints() {
        bottomStackView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        cardStack.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.bottom.equalTo(bottomStackView.snp.top).offset(-20)
        }
        
        wrapperForText.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.bottom.equalTo(myMatchImageView.snp.top).offset(-600)
            make.height.equalTo(117)
        }
        
        titleTextLabel.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(subTextLbl.snp.top).offset(-8)
        }
        
        subTextLbl.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        myMatchImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(300)
            make.width.height.equalTo(110)
        }
        
        partnerMatchImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(myMatchImageView.snp.right).offset(25)
            make.centerX.equalToSuperview().offset(-300)
            make.width.height.equalTo(110)
        }
        
        sendMsgBtn.snp.makeConstraints { (make) in
            make.top.equalTo(partnerMatchImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview().offset(200)
            make.width.equalTo(245)
            make.height.equalTo(46)
        }
        
        keepSwipingBtn.snp.makeConstraints { (make) in
            make.top.equalTo(sendMsgBtn.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(-200)
            make.width.equalTo(245)
            make.height.equalTo(46)
        }
    }
}


// MARK: Extension for location manager
extension RadarViewController {
    func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        self.geoFireRef = Ref().databaseGeo
        self.geoFire = GeoFire(firebaseRef: self.geoFireRef)
    }
}


// MARK: CheckIfMatch
extension RadarViewController {
    func checkIfMatch(for card: Card) {
        Ref().databaseActionForUser(uid: card.user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            if dict.keys.contains(Api.User.currentUserId) {
                if dict[Api.User.currentUserId]! {
                    UIView.animate(withDuration: 0.45, animations: {
                        self.blurEffectView.isHidden = false
                        self.blurEffectView.alpha = 1
                    }, completion: { (bool) in
                        print("Match")
                        Api.User.match(from: Api.User.currentUserId, to: card.user.uid, bool: true)
                        Api.User.match(from: card.user.uid, to: Api.User.currentUserId, bool: true)
                        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn ,animations: {
                            self.wrapperForText.snp.updateConstraints { (make) in
                                make.bottom.equalTo(self.myMatchImageView.snp.top).offset(-20)
                            }
                            
                            self.myMatchImageView.snp.updateConstraints({ (make) in
                                make.centerX.equalToSuperview().offset(66.25)
                            })
                            self.myMatchImageView.transform.rotated(by: 4 * CGFloat.pi)
                            
                            self.partnerMatchImageView.snp.updateConstraints({ (make) in
                                make.centerX.equalToSuperview().offset(-66.25)
                            })
                            self.partnerMatchImageView.transform.rotated(by: 4 * CGFloat.pi)
                            
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                        
                        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                        rotateAnimation.fromValue = 0.0
                        rotateAnimation.toValue = CGFloat(-.pi * 2.0)
                        rotateAnimation.duration = 0.8
                        self.myMatchImageView.layer.add(rotateAnimation, forKey: nil)
                        
                        rotateAnimation.toValue = CGFloat(.pi * 2.0)
                        self.partnerMatchImageView.layer.add(rotateAnimation, forKey: nil)
                        
                        
                        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
                            self.sendMsgBtn.snp.updateConstraints({ (make) in
                                make.centerX.equalToSuperview()
                            })
                            
                            self.keepSwipingBtn.snp.updateConstraints({ (make) in
                                make.centerX.equalToSuperview()
                            })
                            
                            self.view.layoutIfNeeded()
                            
                        }, completion: nil)
                    })
                    
                    self.matchedPartner = card.user
                    
                    if let partnerImage = card.user.profileImage {
                        self.partnerMatchImageView.image = partnerImage
                    }
                    Api.User.getUserInfoSingleEvent(uid: Api.User.currentUserId, onSuccess: { (user) in
                        if let myImage = user.profileImage {
                            self.myMatchImageView.image = myImage
                        }
                    })
                    
                    self.subTextLbl.text = "You and \(card.user.username) have liked each other"
                    
                    
                    
                    //                Api.User.getUserInfoSingleEvent(uid: Api.User.currentUserId, onSuccess: { (user) in
                    //
                    //                })
                }
            }
        }
    }
}


// MARK: location manager delegate

extension RadarViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showError("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager , didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        let updatedLocation: CLLocation = locations.first!
        let newCordinate: CLLocationCoordinate2D = updatedLocation.coordinate
        // update location
        let userDefaults = UserDefaults.standard
        userDefaults.set("\(newCordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
            let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String{
            let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
            Ref().databaseSpecificUser(uid: Api.User.currentUserId).updateChildValues([LONGITUDE: userLong, LATITUDE: userLat])
            self.geoFire.setLocation(location, forKey: Api.User.currentUserId) { (error) in
                if error == nil {
                    // Find Users
                    self.findUsers()
                }
            }
        }
    }
}

// MARK: Actions and pan
extension RadarViewController {
    @objc func nopeDidTaped() {
        guard let firstCard = cards.first else {
            return
        }
        saveToFirebase(like: false, card: firstCard)
        swipeAnimation(translation: -750, angle: 15)
        setupTransforms()
    }
    
    @objc func likeDidTaped() {
        guard let firstCard = cards.first else {
            return
        }
        saveToFirebase(like: true, card: firstCard)
        swipeAnimation(translation: 750, angle: 15)
        setupTransforms()
    }
    
    @objc func dissmissblur() {
        UIView.animate(withDuration: 0.45, animations: {
            self.blurEffectView.alpha = 0
        }) { (bool) in
            self.blurEffectView.isHidden = true
        }
    }
    
    @objc func moveToPartnerChat() {
        dissmissblur()
        let chatVC = ChatViewController()
        chatVC.imagePartner = matchedPartner.profileImage!
        chatVC.partnerUsername = matchedPartner.username
        chatVC.partnerId = matchedPartner.uid
        chatVC.partnerUser = matchedPartner
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! Card
        let translation = gesture.translation(in: cardStack)
        
        switch gesture.state {
        case .began:
            panInitialLocation = gesture.location(in: cardStack)
        case .changed:
            card.center.x = cardInitialLocationCenter.x + translation.x
            card.center.y = cardInitialLocationCenter.y + translation.y
            if translation.x > 0 {
                // show like icon
                card.likeView.alpha = abs(translation.x * 2) / self.cardStack.bounds.midX
                card.nopeView.alpha = 0
            } else {
                // show nope icon
                card.nopeView.alpha = abs(translation.x * 2) / self.cardStack.bounds.midX
                card.likeView.alpha = 0
            }
            card.transform = self.transform(view: card, for: translation)
        case .ended:
            if translation.x > 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x + 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                self.saveToFirebase(like: true, card: card)
                self.updateCards(card: card)
                
                return
            }
            else if translation.x < -75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x - 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                saveToFirebase(like: false, card: card)
                self.updateCards(card: card)
                
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                card.center = self.cardInitialLocationCenter
                card.likeView.alpha = 0
                card.nopeView.alpha = 0
                card.transform = CGAffineTransform.identity
            }
            
        default: break
        }
        
    }
}


// MARK: Swipe animation
extension RadarViewController {
    func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        guard let firstCard = cards.first else {
            return
        }
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == firstCard.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        
        self.setupGestures()
        
        CATransaction.setCompletionBlock {
            
            firstCard.removeFromSuperview()
        }
        firstCard.layer.add(translationAnimation, forKey: "translation")
        firstCard.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
}
