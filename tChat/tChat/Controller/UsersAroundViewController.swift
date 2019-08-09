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
        let layout = UICollectionViewLayout()
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
        
        // Add this custom Segmented Control to our view
        self.view.addSubview(genderSegmentedControl)
    }
    
    func setupShowMapBtn() {
        showMapBtn.setImage(UIImage(named: "icon-showmap"), for: .normal)
        showMapBtn.setTitle("Btn", for: .normal)
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
            make.right.left.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func findUsers() {
        
        if queryHandle != nil, myQuery != nil {
            myQuery.removeObserver(withFirebaseHandle: queryHandle)
            myQuery = nil
            queryHandle = nil
        }
        
        guard let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
            let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String, let geoFire = geoFire else {
                return
        }
        
        self.users.removeAll()
        
        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        myQuery = geoFire.query(at: location, withRadius: distance)
        queryHandle = myQuery.observe(.keyEntered) { (key, location) in
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
                        default: break
                    }
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
            default: print("default")
            }
        }
    }
    
    @objc func refreshDidTaped() {
        findUsers()
    }
}


extension UsersAroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIER_CELL_USERS_AROUND, for: indexPath) as! UserAroundCollectionViewCell
        let user = users[indexPath.row]
        cell.controller = self
        cell.loadData(user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3 - 2, height: view.frame.size.width / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

class UserAroundCollectionViewCell: UICollectionViewCell {
    var avatar = UIImageView()
    var onlineStatusView = UIImageView()
    var ageLabel = UILabel()
    var distanceLabel = UILabel()
    var helperImageView = UIImageView()
    var user: User!
    var inboxChangedOnlineHandle: DatabaseHandle!
    var inboxChangedProfileHandle: DatabaseHandle!
    var controller: UsersAroundViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        setupOnlineStatusView()
        setupAvatar()
        setupAgeLabel()
        setupDistanceLabel()
        setupHelperImageView()
    }
    
    func setupAvatar() {
        avatar.contentMode = .scaleAspectFill
        addSubview(avatar)
    }
    
    func setupAgeLabel() {
        ageLabel.textColor = .white
        ageLabel.shadowColor = .black
        addSubview(ageLabel)
    }
    
    func setupDistanceLabel() {
        distanceLabel.textColor = .white
        distanceLabel.font = UIFont.systemFont(ofSize: 12)
        distanceLabel.shadowColor = .black
        addSubview(distanceLabel)
    }
    
    func setupOnlineStatusView() {
        onlineStatusView.backgroundColor = .red
        onlineStatusView.layer.cornerRadius = 10/2
        onlineStatusView.clipsToBounds = true
        addSubview(onlineStatusView)
    }
    
    func setupHelperImageView() {
        helperImageView.backgroundColor = UIColor.rgbColor(r: 0, g: 0, b: 0, alpha: 0.5)
        addSubview(helperImageView)
    }
    
    func createConstraints() {
        avatar.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        onlineStatusView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(4)
            make.width.height.equalTo(10)
        }
        ageLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.bottom.equalToSuperview()
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(6)
            make.top.equalTo(ageLabel)
        }
        helperImageView.snp.makeConstraints { (make) in
            make.height.equalTo(26)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func loadData(_ user: User) {
        self.user = user
        avatar.loadImage(user.profileImageUrl)
        if let age = user.age {
            self.ageLabel.text = "\(age)"
        } else {
            self.ageLabel.text = ""
        }
        
        let refOnline = Ref().databaseIsOnline(uid: user.uid)
        refOnline.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, Any> {
                if let active = snap["online"] as? Bool {
                    self.onlineStatusView.backgroundColor = active == true ? .green : .red
                }
            }
        }
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        inboxChangedOnlineHandle = refOnline.observe(.childChanged) { (snapshot) in
            if let snap = snapshot.value {
                if snapshot.key == "online" {
                    self.onlineStatusView.backgroundColor = (snap as! Bool) == true ? .green : .red
                }
            }
        }
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        inboxChangedProfileHandle = refUser.observe(.childChanged) { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                self.controller.usersAroundCollectionView.reloadData()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let refOnline = Ref().databaseIsOnline(uid: self.user.uid)
        if inboxChangedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
        }
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        if inboxChangedProfileHandle != nil {
            refUser.removeObserver(withHandle: inboxChangedProfileHandle)
        }
        
        onlineStatusView.backgroundColor = .red
    }
    
}


extension UsersAroundViewController: CLLocationManagerDelegate {
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
            self.geoFire.setLocation(location, forKey: Api.User.currentUserId) { (error) in
                if error == nil {
                    // Find Users
                    self.findUsers()
                }
            }
        }
    }
}
