//
//  EXT-SignUpViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/28/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SnapKit
import ProgressHUD
import CoreLocation

extension SignUpViewController {

    func setupCloseBtn() {
        closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(moveBackToWelcomePage), for: .touchUpInside)
        view.addSubview(closeBtn)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        let title = "Sign Up"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ])
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        view.addSubview(titleLabel)
    }
    
    func setupAvatar() {
        avatar = UIImageView()
        avatar.image = UIImage()
        avatar.backgroundColor = .gray
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        view.addSubview(avatar)
    }
    
    func setupWrapperViewForFullName() {
        wrapperViewForFullName = UIView()
        wrapperViewForFullName.layer.borderWidth = 1
        wrapperViewForFullName.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210, alpha: 1).cgColor
        wrapperViewForFullName.layer.cornerRadius = 3
        wrapperViewForFullName.clipsToBounds = true
        view.addSubview(wrapperViewForFullName)
    }
    
    func setupFullNameTextField() {
        fullNameTextField = UITextField()
        fullNameTextField.autocapitalizationType = .none
        fullNameTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgbColor(r: 170, g: 170, b: 170, alpha: 1)])
        fullNameTextField.attributedPlaceholder = placeholderAttr
        fullNameTextField.textColor = UIColor.rgbColor(r: 99, g: 99, b: 99, alpha: 1)
        wrapperViewForFullName.addSubview(fullNameTextField)
    }
    
    func setupWrapperViewForEmail() {
        wrapperViewForEmail = UIView()
        wrapperViewForEmail.layer.borderWidth = 1
        wrapperViewForEmail.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210, alpha: 1).cgColor
        wrapperViewForEmail.layer.cornerRadius = 3
        wrapperViewForEmail.clipsToBounds = true
        view.addSubview(wrapperViewForEmail)
    }
    
    func setupEmailAddressTextField() {
        emailAddressTextField = UITextField()
        emailAddressTextField.borderStyle = .none
        emailAddressTextField.autocapitalizationType = .none
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgbColor(r: 170, g: 170, b: 170, alpha: 1)])
        emailAddressTextField.attributedPlaceholder = placeholderAttr
        emailAddressTextField.textColor = UIColor.rgbColor(r: 99, g: 99, b: 99, alpha: 1)
        wrapperViewForEmail.addSubview(emailAddressTextField)
    }
    
    func setupWrapperViewForPassword() {
        wrapperViewForPassword = UIView()
        wrapperViewForPassword.layer.borderWidth = 1
        wrapperViewForPassword.layer.borderColor = UIColor.rgbColor(r: 210, g: 210, b: 210, alpha: 1).cgColor
        wrapperViewForPassword.layer.cornerRadius = 3
        wrapperViewForPassword.clipsToBounds = true
        view.addSubview(wrapperViewForPassword)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.borderStyle = .none
        passwordTextField.autocapitalizationType = .none
        let placeholderAttr = NSAttributedString(string: "Password( 8+ Characters)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgbColor(r: 170, g: 170, b: 170, alpha: 1)])
        passwordTextField.attributedPlaceholder = placeholderAttr
        passwordTextField.textColor = UIColor.rgbColor(r: 99, g: 99, b: 99, alpha: 1)
        passwordTextField.isSecureTextEntry = true
        wrapperViewForPassword.addSubview(passwordTextField)
    }
    
    func setupSignUpBtn() {
        signUpBtn = UIButton()
        signUpBtn.backgroundColor = .black
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpBtn.layer.cornerRadius = 5
        signUpBtn.clipsToBounds = true
        signUpBtn.addTarget(self, action: #selector(signUpDidTaped), for: .touchUpInside)
        view.addSubview(signUpBtn)
    }
    
    func setupAlreadyHaveAccountBtn() {
        alreadyHaveAccountBtn = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        let attributedSubText = NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65) ])
        attributedText.append(attributedSubText)
        alreadyHaveAccountBtn.setAttributedTitle(attributedText, for: .normal)
        alreadyHaveAccountBtn.addTarget(self, action: #selector(moveToSignInPage), for: .touchUpInside)
        view.addSubview(alreadyHaveAccountBtn)
    }
    
    @objc func moveToSignInPage() {
        let signInPage = SignInViewController()
//        present(signInPage, animated: true, completion: nil)
        navigationController?.pushViewController(signInPage, animated: true)
    }
    
    @objc func moveBackToWelcomePage() {
        navigationController?.popViewController(animated: true)
    }
    
    func validateFields() {
        guard let username = self.fullNameTextField.text, !username.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_USERNAME)
            return
        }
        
        guard let email = self.emailAddressTextField.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL)
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
            return
        }
        
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
    }
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show()
        Api.User.signUp(withUsername: self.fullNameTextField.text!, email: self.emailAddressTextField.text!, password: self.passwordTextField.text!, image: self.image, onSuccess: {
            ProgressHUD.dismiss()
            Api.User.isOnline(bool: true)
            print("success")
            onSuccess()
        }) { (err) in
            onError(err)
            print("error")
        }
        
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

extension SignUpViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showError("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let updatedLocation: CLLocation = locations.first!
        let newCordinate: CLLocationCoordinate2D = updatedLocation.coordinate
        
        // update location
        let userDefaults = UserDefaults.standard
        userDefaults.set("\(newCordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
    }
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            avatar.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
