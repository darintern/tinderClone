//
//  UserAnnotaion.swift
//  tChat
//
//  Created by Aibol Tungatarov on 8/10/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class UserAnnotation: MKPointAnnotation {
    var uid: String?
    var age: Int?
    var profileImage: UIImage?
    var isMale: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
