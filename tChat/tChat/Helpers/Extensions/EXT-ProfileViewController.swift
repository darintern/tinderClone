//
//  EXT-ProfileViewController.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/4/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController {
    
    @objc func presentPicker() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_PROFILE, for: indexPath) as! ProfileTableViewCell
        if indexPath.section == 0 {
            cell.dataTextField.isHidden = false
            if indexPath.section == 0 {
                cell.dataTextField.text = sectionZero[indexPath.row]
            }
//            else {
//                cell.dataTextField.text = sectionZero[indexPath.row]
//            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.dataTextField.isHidden = false
                if let age = age {
                    cell.dataTextField.text = "\(age)"
                } else {
                    cell.dataTextField.placeholder = "Optional"
                }
            } else {
                cell.segmentedControl.isHidden = false
                if let isMale = isMale {
                    cell.segmentedControl.selectedSegmentIndex = (isMale) ? 0 : 1
                }
            }
        } else if indexPath.section == 2 || indexPath.section == 3 {
            cell.label.isHidden = false
            cell.accessoryType = .disclosureIndicator
            cell.label.text = indexPath.section == 2 ? sectionOne[indexPath.row] : sectionTwo[indexPath.row]
        } else if indexPath.section == 4 {
            cell.btn.isHidden = false
        }
        return cell
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
