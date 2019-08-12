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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "tChat"
        setupViews()
        createConstraints()
        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
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
    
    @objc func nopeDidTaped() {
        guard let firstCard = cards.first else {
            return
        }
        swipeAnimation(translation: -750, angle: 15)
        setupTransforms()
    }
    
    @objc func likeDidTaped() {
        guard let firstCard = cards.first else {
            return
        }
        swipeAnimation(translation: 750, angle: 15)
        setupTransforms()
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
