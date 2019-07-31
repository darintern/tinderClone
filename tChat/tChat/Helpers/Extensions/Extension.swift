//
//  Extension.swift
//  tChat
//
//  Created by Aibol Tungatarov on 7/30/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil ) {
        self.image = UIImage()
        guard let string = urlString else { return }
        guard let url = URL(string: string) else { return }
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
}

extension UIColor {
    static func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
