//
//  MessageTableViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/1/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class MessageTableViewCell: UITableViewCell {
    var partnerProfileImageView = UIImageView()
    var bubbleMsgView = UIView()
    var textMsgLbl = UILabel()
    var dateMsgLbl = UILabel()
    var bubbleImageView = UIImageView()
    var activityIndicatorView = UIActivityIndicatorView()
    var playButton = UIButton()
    var widthConstraintForBubble = 250
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var message: Message!
    var observation: Any? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        createConstraints()
        textMsgLbl.isHidden = true
        bubbleImageView.isHidden = true
        partnerProfileImageView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textMsgLbl.isHidden = true
        bubbleImageView.isHidden = true
        partnerProfileImageView.isHidden = true
        
        if observation != nil {
            stopObservers()
        }
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        playButton.isHidden = false
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func stopObservers() {
        player?.removeObserver(self, forKeyPath: "status")
        observation = nil
    }
    
    func configureCell(uid: String, message: Message, image: UIImage) {
        self.message = message
        let text = message.text
        if !text.isEmpty {
            textMsgLbl.text = text
            textMsgLbl.isHidden = false
    
            let widthValue = text.estimateFrameForText(text).width + 40
            if widthValue < 100 {
                widthConstraintForBubble = 100
                bubbleMsgView.snp.makeConstraints { (make) in
                    make.width.equalTo(widthConstraintForBubble).priority(1000)
                }
            }
            else {
                widthConstraintForBubble = Int(widthValue)
                bubbleMsgView.snp.makeConstraints { (make) in
                    make.width.equalTo(widthConstraintForBubble).priority(1000)
                }
            }
            dateMsgLbl.textColor = .lightGray
        } else {
            bubbleImageView.isHidden = false
            bubbleImageView.loadImage(message.imageUrl)
            bubbleImageView.layer.borderColor = UIColor.clear.cgColor
            bubbleMsgView.snp.makeConstraints { (make) in
                make.width.lessThanOrEqualTo(message.width).priority(1000)
            }
            dateMsgLbl.textColor = .white
        }
        
        if uid == message.from {
            bubbleMsgView.backgroundColor = .groupTableViewBackground
            bubbleMsgView.layer.borderColor = UIColor.clear.cgColor
            let leftConstraintValue: CGFloat = UIScreen.main.bounds.width - 8 - CGFloat(widthConstraintForBubble)
            bubbleMsgView.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-8).priority(1000)
                make.left.equalToSuperview().offset(leftConstraintValue).priority(1000)
            }
        }
        else {
            partnerProfileImageView.isHidden = false
            bubbleMsgView.backgroundColor = .white
            bubbleMsgView.layer.borderColor = UIColor.lightGray.cgColor
            partnerProfileImageView.image = image
            let rightConstraintValue: CGFloat = UIScreen.main.bounds.width - 55 - CGFloat(widthConstraintForBubble)
            bubbleMsgView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(55).priority(1000)
                make.right.equalToSuperview().offset(-rightConstraintValue).priority(1000)
            }
        }
        let date = Date(timeIntervalSince1970: message.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateMsgLbl.text = dateString
        
    }
    
    func setupViews() {
        setupPartnerProfileImageView()
        setupBubleMsgView()
    }
    
    func setupPartnerProfileImageView() {
        partnerProfileImageView.layer.cornerRadius = 16
        partnerProfileImageView.clipsToBounds = true
        addSubview(partnerProfileImageView)
    }
    
    func setupBubleMsgView() {
        bubbleMsgView.layer.cornerRadius = 15
        bubbleMsgView.layer.borderWidth = 0.4
        bubbleMsgView.clipsToBounds = true
        setupActivityIndicatorView()
        setupTextMsgLbl()
        setupDateMsgLbl()
        setupBubbleImageView()
        setupPlayButton()
        addSubview(bubbleMsgView)
    }
    
    func setupActivityIndicatorView() {
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        bubbleMsgView.addSubview(activityIndicatorView)
    }
    
    func setupTextMsgLbl() {
        textMsgLbl.text = "Message"
        textMsgLbl.numberOfLines = 0
        bubbleMsgView.addSubview(textMsgLbl)
    }
    
    func setupDateMsgLbl() {
        dateMsgLbl.text = "timestamp"
        dateMsgLbl.font = .systemFont(ofSize: 14)
        dateMsgLbl.textColor = .white
        dateMsgLbl.textAlignment = .right
        bubbleMsgView.addSubview(dateMsgLbl)
    }
    
    func setupBubbleImageView() {
//        bubbleImageView.layer.cornerRadius = 15
        bubbleImageView.clipsToBounds = true
        bubbleImageView.contentMode = .scaleAspectFill
        bubbleMsgView.addSubview(bubbleImageView)
    }
    
    func setupPlayButton() {
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playBtnDidTaped), for: .touchUpInside)
        bubbleMsgView.addSubview(playButton)
    }
    
    func createConstraints() {
        partnerProfileImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-12)
            make.height.width.equalTo(32)
        }
        bubbleMsgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8).priority(750)
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(55).priority(750)
        }
        textMsgLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(8)
        }
        dateMsgLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(textMsgLbl.snp.bottom)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(15)
        }
        activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        bubbleImageView.snp.makeConstraints { (make) in
//            make.left.right.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        playButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    @objc func playBtnDidTaped() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        handlePlay()
    }
    
    func handlePlay() {
        let videoUrl = message.videoUrl
        if videoUrl.isEmpty {
            return
        }
        
        if let url = URL(string: videoUrl) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = bubbleImageView.frame
            observation = player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            bubbleMsgView.layer.addSublayer(playerLayer!)
            player?.play()
            playButton.isHidden = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status = player!.status
            switch(status) {
            case .readyToPlay:
                activityIndicatorView.isHidden = true
                activityIndicatorView.stopAnimating()
                break
            case .unknown, .failed:
                break
                
            }
        }
    }

}
