//
//  UsersAroundViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/7/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GeoFire
import ProgressHUD

class UsersAroundViewController: UIViewController {
    var slider = UISlider()
    var distanceLabel = UILabel()
    var genderSegmentedControl = UISegmentedControl()
    var showMapBtn = UIButton()
    var usersAroundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    var locationManager = CLLocationManager()
    var userLat = ""
    var userLong = ""
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var myQuery: GFQuery!
    var queryHandle: DatabaseHandle!
    var distance: Double = 500
    var users: [User] = []
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        configureLocationManager()
        setupNavigationBar()
        setupGenderSegmentedControl()
        setupShowMapBtn()
        setupUsersAroundCollectionView()
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
        slider.value = Float(distance)
        slider.isContinuous = true
        slider.tintColor = PURPLE_COLOR
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: .valueChanged)
    }
    
    func setupDistanceLabel() {
        distanceLabel.text = "\(Int(distance)) km"
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.textColor = PURPLE_COLOR
    }
    
    func setupGenderSegmentedControl() {
        let items = ["Male", "Female", "Both"]
        genderSegmentedControl = UISegmentedControl(items: items)
        genderSegmentedControl.selectedSegmentIndex = 0
    
        // Style the Segmented Control
        genderSegmentedControl.tintColor = PURPLE_COLOR
        
        genderSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // Add this custom Segmented Control to our view
        self.view.addSubview(genderSegmentedControl)
    }
    
    func setupShowMapBtn() {
        showMapBtn.setImage(UIImage(named: "icon-showmap"), for: .normal)
        showMapBtn.setTitle("Btn", for: .normal)
        showMapBtn.addTarget(self, action: #selector(moveToMap), for: .touchUpInside)
        self.view.addSubview(showMapBtn)
    }
    
    func setupUsersAroundCollectionView() {
        usersAroundCollectionView.delegate = self
        usersAroundCollectionView.dataSource = self
        usersAroundCollectionView.backgroundColor = .white
        usersAroundCollectionView.register(UserAroundCollectionViewCell.self, forCellWithReuseIdentifier: IDENTIFIER_CELL_USERS_AROUND)
        view.addSubview(usersAroundCollectionView)
    }
    
    func createConstraints() {
        genderSegmentedControl.snp.makeConstraints { (make) in
            make.left.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(27)
        }
        showMapBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.equalTo(genderSegmentedControl.snp.right).offset(20)
            make.top.equalTo(genderSegmentedControl)
            make.height.width.equalTo(25)
        }
        usersAroundCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(genderSegmentedControl.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
        }
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
                    switch self.genderSegmentedControl.selectedSegmentIndex {
                    case 0:
                        if user.isMale! {
                            self.users.append(user)
                        }
                    case 1:
                        if !user.isMale! {
                            self.users.append(user)
                        }
                    case 2:
                        self.users.append(user)
                    default:
                        break
                    }
                    print(self.users.count)
                    self.usersAroundCollectionView.reloadData()
                })
            }
        }
    }
    
    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            distance = Double(slider.value)
            distanceLabel.text = "\(Int(distance))"
            switch touchEvent.phase {
            case .ended:
                findUsers()
            default: break
            }
        }
    }
    
    @objc func segmentChanged() {
        findUsers()
    }
    
    @objc func refreshDidTaped() {
        findUsers()
    }
    
    @objc func moveToMap() {
        let mapVC = MapViewController()
        mapVC.users = users
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}
