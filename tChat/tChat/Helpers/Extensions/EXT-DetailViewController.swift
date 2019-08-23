//
//  EXT-DetailViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/10/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension DetailViewController {
    func setupAvatarImageView() {
        avatarImageView.image = user.profileImage
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        avatarImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        headerView.addSubview(avatarImageView)
    }
    
    func setupGenderImageView() {
        if let isMale = user.isMale {
            let imgName = isMale ? "icon-male" : "icon-female"
            genderImageView.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        } else {
            genderImageView.image = UIImage(named: "icon-gender")?.withRenderingMode(.alwaysTemplate)
        }
        genderImageView.tintColor = .white
        headerView.addSubview(genderImageView)
    }
    
    func setupAgeLabel() {
        ageLbl.font = .systemFont(ofSize: 22, weight: .medium)
        ageLbl.textColor = .white
        if let age = user.age {
            ageLbl.text = "\(age)"
        } else {
            ageLbl.text = ""
        }
        headerView.addSubview(ageLbl)
    }
    
    func setupBackButton() {
        backBtn.backgroundColor = .gray
        backBtn.layer.cornerRadius = 35/2
        backBtn.clipsToBounds = true
        backBtn.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backBtnDidTaped), for: .touchUpInside)
        headerView.addSubview(backBtn)
        
    }
    
    func setupSendButton() {
        sendBtn.setTitle("Send Message", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnDidTaped), for: .touchUpInside)
        sendBtn.backgroundColor = UIColor.rgbColor(r: 231, g: 76, b: 60, alpha: 1)
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.layer.cornerRadius = 5
        sendBtn.clipsToBounds = true
        headerView.addSubview(sendBtn)
    }
    
    func setupUsernameLbl() {
        usernameLbl.font = .systemFont(ofSize: 35, weight: .medium)
        usernameLbl.textColor = .white
        usernameLbl.text = user.username
        headerView.addSubview(usernameLbl)
    }
    
    func setupDetailTableView() {
        detailTableView.contentInsetAdjustmentBehavior = .never
        detailTableView.register(DetailMapTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_DETAIL)
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        detailTableView.delegate = self
        detailTableView.dataSource = self
        view.addSubview(detailTableView)
    }
    
    func createConstraints() {
        detailTableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(350)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalToSuperview()
        }
        backBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(35)
        }
        genderImageView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(30)
        }
        ageLbl.snp.makeConstraints { (make) in
            make.left.equalTo(genderImageView.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-15)
        }
        usernameLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(5)
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(30)
        }
    }
    
    @objc func sendBtnDidTaped() {
        let chatVC = ChatViewController()
        chatVC.imagePartner = avatarImageView.image!
        chatVC.partnerUsername = usernameLbl.text!
        chatVC.partnerUser = user
        chatVC.partnerId = user.uid
        present(UINavigationController(rootViewController: chatVC), animated: true, completion: nil)
    }
    
    @objc func backBtnDidTaped() {
        let mainVC = MainController()
        mainVC.moveToMessagesPage()
        let mainNavC = UINavigationController(rootViewController: mainVC)
        present(mainNavC, animated: true, completion: nil)
    }
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.imageView?.image = UIImage(named: "phone")
            cell.textLabel?.text = "123456789"
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.imageView?.image = UIImage(named: "map-1")
            if !user.latitude.isEmpty && !user.longitude.isEmpty {
                let location = CLLocation(latitude: CLLocationDegrees(Double(user.latitude)!), longitude: CLLocationDegrees(Double(user.longitude)!))
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if error == nil, let placemarkArray = placemarks, placemarkArray.count > 0 {
                        if let placemark = placemarkArray.last {
                            var text = ""
                            if let thoroughFare = placemark.thoroughfare {
                                text = "\(thoroughFare)"
                                cell.textLabel?.text = text
                            }
                            if let postalCode = placemark.postalCode {
                                text = text + " " + postalCode
                                cell.textLabel?.text = text
                            }
                            if let locality = placemark.locality {
                                text = text + " "  + locality
                                cell.textLabel?.text = text
                            }
                            if let country = placemark.country {
                                text = text + " "  + country
                                cell.textLabel?.text = text
                            }
                        }
                    } else {
                        print("\(error?.localizedDescription)")
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "\(user.status)"
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_DETAIL, for: indexPath) as! DetailMapTableViewCell
            if !user.latitude.isEmpty && !user.longitude.isEmpty {
                let location = CLLocation(latitude: CLLocationDegrees(Double(user.latitude)!), longitude: CLLocationDegrees(Double(user.longitude)!))
                cell.controller = self
                cell.configure(location: location)
            }
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 300
        }
        return 44
    }
    
    
}
