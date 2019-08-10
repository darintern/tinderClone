//
//  MapViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/10/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController {
    var mapView = MKMapView()
    var backBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createConstraints()
    }
    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews() {
        setupMapView()
        setupBackBtn()
        addAnotation()
    }
    
    func setupBackBtn() {
        backBtn.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnDidTaped), for: .touchUpInside)
        backBtn.tintColor = PURPLE_COLOR
        view.addSubview(backBtn)
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
    }
    
    func createConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
    }
    
    func addAnotation() {
        var nearbyAnotations: [MKAnnotation] = []
        for user in users {
            let location = CLLocation(latitude: Double(user.latitude)!, longitude: Double(user.longitude)!)
            let annotation = UserAnnotation()
            annotation.title = user.username
            if let age = user.age {
                annotation.subtitle = "age: \(age)"
            }
            if let isMale = user.isMale {
                annotation.isMale = isMale
            }
            annotation.profileImage = user.profileImage
            annotation.coordinate = location.coordinate
            nearbyAnotations.append(annotation)
        }
        self.mapView.addAnnotations(nearbyAnotations)
    }
    
    @objc func backBtnDidTaped() {
        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        var annotationView: MKAnnotationView!
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "icon-user")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = deqAnno
            annotationView.annotation = annotation
        } else {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annoView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = annoView
        }
        
        if let annotationView = annotationView, let anno = annotation as? UserAnnotation {
            annotationView.canShowCallout = true
            
            let image = anno.profileImage
            let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            resizeRenderImageView.layer.cornerRadius = 25
            resizeRenderImageView.clipsToBounds = true
            resizeRenderImageView.contentMode = .scaleAspectFill
            resizeRenderImageView.image = image
            
            UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
            resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView.image = thumbnail
            
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "icon-direction"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
            
            
            let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            if let isMale = anno.isMale {
                leftIconView.image = isMale ? UIImage(named: "icon-male") : UIImage(named: "icon-female")
            } else {
                leftIconView.image = UIImage(named: "icon-gender")
            }
            annotationView.leftCalloutAccessoryView = leftIconView
        }
        return annotationView
    }
}
