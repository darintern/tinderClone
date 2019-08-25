//
//  MyLikesViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

class MyLikesViewController: UIViewController {

    var usersArray = [User]()
//    var cardsArray = [Card]()
    var myLikesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMyLikesCollectionView()
        createConstraints()
    }
    
    func setupMyLikesCollectionView() {
        myLikesCollectionView.delegate = self
        myLikesCollectionView.dataSource = self
        myLikesCollectionView.register(MyLikesCollectionViewCell.self, forCellWithReuseIdentifier: IDENTIFIER_CELL_LIKES)
        view.addSubview(myLikesCollectionView)
    }
    
    func createConstraints() {
        myLikesCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension MyLikesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIER_CELL_LIKES, for: indexPath) as! MyLikesCollectionViewCell
//        let card = cardsArray[indexPath.row]
//        card.user =
//        cell.card =
        return cell
    }
    
    

}


class MyLikesCollectionViewCell: UICollectionViewCell {
    
//    var card: Card!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    func createConstraints() {
        
    }
}
