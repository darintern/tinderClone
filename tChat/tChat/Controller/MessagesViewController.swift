//
//  MessagesViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class MessagesViewController: UIViewController {
    var lastInboxDate: Double?
    var inboxArray = [Inbox]()
    var newMatches = [User]()
    
    let messagesTableView = UITableView()
    let newMatchesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    var avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        observeUsers()
        setupViews()
        createConstraints()
        observeInbox()
    }
    
    func observeInbox() {
        Api.Inbox.lastMessages(uid: Api.User.currentUserId) { (inbox) in
            if !self.inboxArray.contains(where: { $0.user.uid == inbox.user.uid}) {
                self.inboxArray.append(inbox)
                self.sortedInbox()
            }
        }
    }
    
    func observeUsers() {
        Api.User.observeUsers { (user) in
            self.newMatches.append(user)
            self.newMatchesCollectionView.reloadData()
        }
    }
    
    func sortedInbox() {
        inboxArray = self.inboxArray.sorted(by: { $0.date > $1.date })
        self.lastInboxDate = inboxArray.last!.date
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
            self.messagesTableView.scrollToRow(at: IndexPath(row: self.inboxArray.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func setupViews() {
        setupNavigationBar()
        setupTableView()
        setupNewMatchesCollectionView()
    }
    
    func setupNewMatchesCollectionView() {
        newMatchesCollectionView.delegate = self
        newMatchesCollectionView.dataSource = self
        newMatchesCollectionView.backgroundColor = .white
        newMatchesCollectionView.register(NewMatchCollectionViewCell.self, forCellWithReuseIdentifier: IDENTIFIER_CELL_NEW_MATCH)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Messages"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupAvatarImageView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-radar"), style: .plain, target: self, action: #selector(moveToRadarVC))
    }
    
    func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.tableFooterView = UIView()
        messagesTableView.backgroundColor = .white
        messagesTableView.dataSource = self
        messagesTableView.register(InboxTableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_MESSAGES)
        messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: IDENTIFIER_CELL_DEFAULT)
        view.addSubview(messagesTableView)
    }
    
    func setupAvatarImageView() {
        let imagePartnerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.contentMode = .scaleAspectFill
        imagePartnerContainerView.addSubview(avatarImageView)
        
        let leftBarBtn = UIBarButtonItem(customView: imagePartnerContainerView)
        navigationItem.leftBarButtonItem = leftBarBtn
        
        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: Notification.Name(rawValue: "updateProfilePhoto"), object: nil)
    }
    
    @objc func updateProfile() {
        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
        }
    }
    
    func loadMore() {
        Api.Inbox.loadMore(start: lastInboxDate, controller: self, from: Api.User.currentUserId) { (inbox) in
            self.messagesTableView.tableFooterView = UIView()
            self.inboxArray.append(inbox)
            if self.inboxArray.contains(where: { $0.channel == inbox.channel }) {
                return
            }
            self.lastInboxDate = self.inboxArray.last!.date
            self.messagesTableView.reloadData()
        }
    }
    
    

//    func setLogoutBarBtn() {
//        let logoutBarBtn = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logoutBarBtnTapped))
//        self.navigationItem.leftBarButtonItem = logoutBarBtn
//    }
    
    func createConstraints() {
        messagesTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
//    @objc func logoutBarBtnTapped() {
//        Api.User.logout()
//    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let lastIndex = self.messagesTableView.indexPathsForVisibleRows?.last {
            if lastIndex.row >= self.inboxArray.count - 2 {
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: 0, width: self.messagesTableView.bounds.width, height: 44)
                self.messagesTableView.tableFooterView = spinner
                self.messagesTableView.tableFooterView?.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.loadMore()
                }
            }
        }
    }
    
    @objc func moveToRadarVC() {
        let radarVC = RadarViewController()
        self.navigationController?.pushViewController(radarVC, animated: true)
    }
}
