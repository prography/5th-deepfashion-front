//
//  UIImageView+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIImageView {
    func setThumbnailImageFromServerURL(_ thumbnailImageURLString: String, placeHolder: UIImage) {
        RequestImage.shared.setImageFromServerURL(thumbnailImageURLString, placeHolder: placeHolder) { image in
            self.image = image
        }
    }
}
