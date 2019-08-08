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
    var mainColor = UIColor.rgbColor(r: 93, g: 79, b: 141, alpha: 1)
    var genderSegmentedControl = UISegmentedControl()
    var showMapBtn = UIButton()
    var usersAroundCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        setupNavigationBar()
        setupGenderSegmentedControl()
        setupShowMapBtn()
        setupUsersAroundCollectionView()
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
        slider.tintColor = mainColor
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: .valueChanged)
    }
    
    func setupDistanceLabel() {
        distanceLabel.text = String(500)
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.textColor = mainColor
    }
    
    func setupGenderSegmentedControl() {
        let items = ["Male", "Female", "Both"]
        genderSegmentedControl = UISegmentedControl(items: items)
        genderSegmentedControl.selectedSegmentIndex = 0
    
        // Style the Segmented Control
        genderSegmentedControl.tintColor = mainColor
        
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
    
    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
        
    }
    
    @objc func refreshDidTaped() {
        
    }
    
}


extension UsersAroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIER_CELL_USERS_AROUND, for: indexPath) as! UserAroundCollectionViewCell
        cell.avatar.image = UIImage(named: "taylor_swift")
        cell.ageLabel.text = "29"
        cell.distanceLabel.text = "500 km"
        cell.backgroundColor = .red
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
}
