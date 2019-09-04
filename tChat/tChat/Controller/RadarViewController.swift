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
    var titleTextLabel = UILabel()
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
    
    func setupViews() {
        setupCardStack()
        setupBottomStackView()
        setupBlurEffectView()
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
    
    func saveToFirebase(like: Bool, card: Card) {
        Ref().databaseActionForUser(uid: Api.User.currentUserId).updateChildValues([card.user.uid : like]) { (error, ref) in
            if error == nil, like {
                // check for match
                self.checkIfMatch(for: card)
            }
        }
    }
    
}


