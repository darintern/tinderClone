//
//  MessageTableViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/1/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit

class MessageTableViewCell: UITableViewCell {
    var partnerProfileImageView = UIImageView()
    var bubbleMsgView = UIView()
    var textMsgLbl = UILabel()
    var dateMsgLbl = UILabel()
    var bubbleImageView = UIImageView()
    var playButton = UIButton()
    var widthConstraintForBubble = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        createConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textMsgLbl.isHidden = true
        bubbleImageView.isHidden = true
        partnerProfileImageView.isHidden = true
    }
    
    func configureCell(uid: String, message: Message, image: UIImage) {
        let text = message.text
        if !text.isEmpty {
            textMsgLbl.text = text
            textMsgLbl.isHidden = false
            let widthValue = text.estimateFrameForText(text).width + 40
            if widthValue < 75 {
                widthConstraintForBubble = 75
                textMsgLbl.snp.makeConstraints { (make) in
                    make.width.equalTo(75)
                }
            }
            else {
                widthConstraintForBubble = Int(widthValue)
                textMsgLbl.snp.makeConstraints { (make) in
                    make.width.equalTo(widthValue)
                }
            }
            dateMsgLbl.textColor = .lightGray
        } else {
            bubbleImageView.isHidden = false
            bubbleImageView.loadImage(message.imageUrl)
            bubbleImageView.layer.borderColor = UIColor.clear.cgColor
            bubbleImageView.snp.makeConstraints { (make) in
                make.width.equalTo(250)
            }
            dateMsgLbl.textColor = .white
        }
        
        if uid == message.from {
            bubbleMsgView.backgroundColor = .groupTableViewBackground
            bubbleMsgView.layer.borderColor = UIColor.clear.cgColor
            let leftConstraintValue: CGFloat = UIScreen.main.bounds.width - 8 - 250
            bubbleMsgView.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-8)
                make.left.equalToSuperview().offset(leftConstraintValue)
            }
        }
        else {
            partnerProfileImageView.isHidden = false
            bubbleMsgView.backgroundColor = .white
            bubbleMsgView.layer.borderColor = UIColor.lightGray.cgColor
            partnerProfileImageView.image = image
            let rightConstraintValue: CGFloat = UIScreen.main.bounds.width - 8 - CGFloat(widthConstraintForBubble)
            bubbleMsgView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(55)
                make.right.equalToSuperview().offset(-rightConstraintValue)
                
            }
            
        }
        
        let date = Date(timeIntervalSince1970: message.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
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
        setupTextMsgLbl()
        setupDateMsgLbl()
        setupBubbleImageView()
        setupPlayButton()
        addSubview(bubbleMsgView)
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
        bubbleImageView.layer.cornerRadius = 15
        bubbleImageView.clipsToBounds = true
        bubbleImageView.contentMode = .scaleAspectFill
        bubbleMsgView.addSubview(bubbleImageView)
    }
    
    func setupPlayButton() {
        playButton.setImage(UIImage(named: "play"), for: .normal)
        bubbleMsgView.addSubview(playButton)
    }
    
    func createConstraints() {
        partnerProfileImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(12)
            make.height.width.equalTo(32)
        }
        bubbleMsgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(partnerProfileImageView)
            make.left.equalToSuperview().offset(55)
        }
        textMsgLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(8)
        }
        dateMsgLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(5)
            make.height.equalTo(15)
        }
        bubbleImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        playButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }

}

extension String {
    func estimateFrameForText(_ text: String ) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
    }

}
