//
//  EXT-DetailViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/10/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController {
    func setupAvatarImageView() {
        avatarImageView.image = user.profileImage
        avatarImageView.contentMode = .scaleAspectFill
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
        headerView.addSubview(usernameLbl)
    }
    
    func setupDetailTableView() {
        detailTableView.contentInsetAdjustmentBehavior = .never
        view.addSubview(detailTableView)
    }
    
    func createConstraints() {
        detailTableView.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalToSuperview()
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
            make.centerX.equalTo(genderImageView)
        }
        usernameLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(5)
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(20)
            make.centerX.equalTo(genderImageView)
            make.width.equalTo(110)
            make.height.equalTo(30)
        }
    }
    
    @objc func sendBtnDidTaped() {
        let chatVC = ChatViewController()
        chatVC.imagePartner = avatarImageView.image!
        chatVC.partnerUsername = usernameLbl.text!
        chatVC.partnerUser = user
        chatVC.partnerId = user.uid
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func backBtnDidTaped() {
        self.navigationController?.popViewController(animated: true)
    }
}
