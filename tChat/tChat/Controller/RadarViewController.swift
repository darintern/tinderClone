//
//  RadarViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/11/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GeoFire
import ProgressHUD
import UIKit

class RadarViewController: UIViewController {
    
    var cardStack = UIView()
    var likeImageView = UIImageView()
    var nopeImageView = UIImageView()
    var refreshImageView = UIImageView()
    var superLikeImageView = UIImageView()
    var boostImageView = UIImageView()
    var bottomStackView = UIStackView()
    var locationManager = CLLocationManager()
    var userLat = ""
    var userLong = ""
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var myQuery: GFQuery!
    var queryHandle: DatabaseHandle!
    var distance: Double = 500
    var users: [User] = []
    var cards: [Card] = []
    var cardInitialLocationCenter: CGPoint!
    var panInitialLocation: CGPoint!
    var blurEffectView: UIVisualEffectView!
    var sendMsgBtn = UIButton()
    var keepSwipingBtn = UIButton()
    var partnerMatchImageView = UIImageView()
    var myMatchImageView = UIImageView()
    var wrapperForText = UIView()
    var titleImageView = UIImageView()
    var subTextLbl = UILabel()
    var matchedPartner: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "tChat"
        setupViews()
        createConstraints()
        configureLocationManager()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.tabBarController?.tabBar.isHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    func setupViews() {
        
        view.addSubview(cardStack)

        refreshImageView.image = UIImage(named: "refresh_circle")
        refreshImageView.contentMode = .scaleAspectFit
        refreshImageView.isUserInteractionEnabled = true
        bottomStackView.addArrangedSubview(refreshImageView)
        
        nopeImageView.image = UIImage(named: "nope_circle")
        nopeImageView.contentMode = .scaleAspectFit
        nopeImageView.isUserInteractionEnabled = true
        let nopeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nopeDidTaped))
        nopeImageView.addGestureRecognizer(nopeTapGestureRecognizer)
        bottomStackView.addArrangedSubview(nopeImageView)
        
        superLikeImageView.image = UIImage(named: "super_like_circle")
        superLikeImageView.contentMode = .scaleAspectFit
        superLikeImageView.isUserInteractionEnabled = true
        bottomStackView.addArrangedSubview(superLikeImageView)
        
        likeImageView.image = UIImage(named: "like_circle")
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.isUserInteractionEnabled = true
        let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeDidTaped))
        likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
        bottomStackView.addArrangedSubview(likeImageView)
        
        boostImageView.image = UIImage(named: "boost_circle")
        boostImageView.contentMode = .scaleAspectFit
        boostImageView.isUserInteractionEnabled = true
        bottomStackView.addArrangedSubview(boostImageView)
        
        bottomStackView.distribution = .fillEqually
        bottomStackView.axis = .horizontal
        view.addSubview(bottomStackView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        blurEffectView.alpha = 0
        blurEffectView.isHidden = true
        
        sendMsgBtn.setAttributedTitle(NSAttributedString(string: "SEND MESSAGE", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
        sendMsgBtn.layer.borderColor = PURPLE_COLOR.cgColor
        sendMsgBtn.backgroundColor = PURPLE_COLOR
        sendMsgBtn.layer.borderWidth = 2
        sendMsgBtn.layer.cornerRadius = 23
        sendMsgBtn.clipsToBounds = true
        sendMsgBtn.addTarget(self, action: #selector(moveToPartnerChat), for: .touchUpInside)
        blurEffectView.contentView.addSubview(sendMsgBtn)
        
        keepSwipingBtn.setAttributedTitle(NSAttributedString(string: "Keep Swiping", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
        keepSwipingBtn.layer.borderColor = PURPLE_COLOR.cgColor
        keepSwipingBtn.backgroundColor = .clear
        keepSwipingBtn.layer.borderWidth = 2
        keepSwipingBtn.layer.cornerRadius = 23
        keepSwipingBtn.clipsToBounds = true
        blurEffectView.contentView.addSubview(keepSwipingBtn)
        
        partnerMatchImageView.image = UIImage(named: "Aibol")
        partnerMatchImageView.contentMode = .scaleAspectFill
        partnerMatchImageView.layer.cornerRadius = 55
        partnerMatchImageView.layer.borderWidth = 2
        partnerMatchImageView.layer.borderColor = UIColor.white.cgColor
        partnerMatchImageView.clipsToBounds = true
        blurEffectView.contentView.addSubview(partnerMatchImageView)
        
        myMatchImageView.image = UIImage(named: "taylor_swift")
        myMatchImageView.contentMode = .scaleAspectFill
        myMatchImageView.layer.cornerRadius = 55
        myMatchImageView.layer.borderWidth = 2
        myMatchImageView.layer.borderColor = UIColor.white.cgColor
        myMatchImageView.clipsToBounds = true
        blurEffectView.contentView.addSubview(myMatchImageView)
        
        blurEffectView.contentView.addSubview(wrapperForText)
        
        titleImageView.image = UIImage(named: "itsamatch")
        titleImageView.contentMode = .scaleAspectFill
//        titleImageView.clipsToBounds = true
        wrapperForText.addSubview(titleImageView)
        
        subTextLbl.text = "You and Kelly Kurk have liked each other"
        subTextLbl.font = .systemFont(ofSize: 14)
        subTextLbl.textAlignment = .center
        subTextLbl.textColor = .white
        subTextLbl.numberOfLines = 0
        wrapperForText.addSubview(subTextLbl)
        
        
        
    }
    
    @objc func moveToPartnerChat() {
        let chatVC = ChatViewController()
        chatVC.imagePartner = matchedPartner.profileImage!
        chatVC.partnerUsername = matchedPartner.username
        chatVC.partnerId = matchedPartner.uid
        chatVC.partnerUser = matchedPartner
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
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
            make.bottom.equalTo(myMatchImageView.snp.top).offset(-20)
            make.height.equalTo(117)
        }
        
        titleImageView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(subTextLbl.snp.top).offset(8)
            make.height.equalTo(78)
        }
        
        subTextLbl.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
        }
        
        myMatchImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(65)
            make.width.height.equalTo(110)
        }
        
        partnerMatchImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(myMatchImageView.snp.right).offset(25)
            make.width.height.equalTo(110)
        }
        
        sendMsgBtn.snp.makeConstraints { (make) in
            make.top.equalTo(partnerMatchImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(245)
            make.height.equalTo(46)
        }
        
        keepSwipingBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(sendMsgBtn.snp.bottom).offset(12)
            make.width.equalTo(245)
            make.height.equalTo(46)
        }
    }
    
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
    
    func findUsers() {
        if queryHandle != nil, myQuery != nil {
            myQuery.removeObserver(withFirebaseHandle: queryHandle!)
            myQuery = nil
            queryHandle = nil
        }
        
        guard let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String, let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String else {
            return
        }
        
        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        self.users.removeAll()
        
        myQuery = geoFire.query(at: location, withRadius: distance)
        
        queryHandle = myQuery.observe(GFEventType.keyEntered) { (key, location) in
            if key != Api.User.currentUserId {
                Api.User.getUserInfoSingleEvent(uid: key, onSuccess: { (user) in
                    if self.users.contains(user) {
                        return
                    }
                    if user.isMale == nil {
                        return
                    }
                    self.users.append(user)
                    self.setupCard(user: user)
                })
            }
        }
    }
    
    func setupCard(user: User) {
        let card = Card()
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.user = user
        card.controller = self
        self.cards.append(card)
        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
        setupTransforms()
        
        if cards.count == 1 {
            cardInitialLocationCenter = card.center
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    func setupTransforms() {
        for (i, card) in cards.enumerated() {
            if i == 0 { continue; }
            
            if i > 3 { return }
            
            var transform = CGAffineTransform.identity
            if i % 2 == 0 {
                transform = transform.translatedBy(x: CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi)/150*CGFloat(i))
            } else {
                transform = transform.translatedBy(x: -CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: -CGFloat(Double.pi)/150*CGFloat(i))
            }
            
            card.transform = transform
        }
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
    
    func updateCards(card: Card) {
        for (index,c) in cards.enumerated() {
            if c.user.uid == card.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        
        setupGestures()
        setupTransforms()
    }
    
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for g in gestures {
                card.removeGestureRecognizer(g)
            }
        }
        
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -translation.x / (view.frame.width / 2)
        return moveBy.rotated(by: rotation)
    }
    
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
    
    func saveToFirebase(like: Bool, card: Card) {
        Ref().databaseActionForUser(uid: Api.User.currentUserId).updateChildValues([card.user.uid : like]) { (error, ref) in
            if error == nil, like {
                // check for match
                self.checkIfMatch(for: card)
            }
        }
    }
    
    func checkIfMatch(for card: Card) {
        Ref().databaseActionForUser(uid: card.user.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            if dict.keys.contains(Api.User.currentUserId) {
                if dict[Api.User.currentUserId]! {
                    
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
                    
                    self.blurEffectView.isHidden = false
                    self.blurEffectView.alpha = 1
                    
                    
                    
                    //                Api.User.getUserInfoSingleEvent(uid: Api.User.currentUserId, onSuccess: { (user) in
                    //
                    //                })
                }
            }
        }
    }
    
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
