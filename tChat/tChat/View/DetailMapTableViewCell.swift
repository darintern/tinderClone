//
//  DetailTableViewCell.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/11/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailMapTableViewCell: UITableViewCell {
    var mapBoldTitleLabel = UILabel()
    var rightIconImageView = UIImageView()
    var mapView = MKMapView()
    var controller: DetailViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        setupMapBoldTitleLabel()
        setupRightIconImageView()
        setupMapView()
    }
    
    func setupMapBoldTitleLabel() {
        mapBoldTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        mapBoldTitleLabel.text = "HOW TO GET HERE"
        addSubview(mapBoldTitleLabel)
    }
    
    func setupRightIconImageView() {
        rightIconImageView.image = UIImage(named: "icon-show-location")
        rightIconImageView.contentMode = .scaleAspectFill
        rightIconImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGesture)
        addSubview(rightIconImageView)
    }
    
    func setupMapView() {
        addSubview(mapView)
    }
    
    func createConstraints(){
        mapBoldTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(15)
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(mapBoldTitleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        rightIconImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.width.height.equalTo(30)
            make.centerX.equalTo(mapBoldTitleLabel)
        }
    }
    
    func configure(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func showMap() {
        let mapVC = MapViewController()
        mapVC.users = [controller.user]
        controller.navigationController?.pushViewController(mapVC, animated: true)
    }
    
}
