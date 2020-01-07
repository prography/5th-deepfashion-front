//
//  UIImageView+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIImageView {
    func presentImageWithAnimation(_ image: UIImage) {
        alpha = 0.0
        self.image = image
        UIView.animate(withDuration: 0.13) {
            self.alpha = 1.0
        }
    }

    func setThumbnailImageFromServerURL(_ thumbnailImageURLString: String?, placeHolder: UIImage) {
        guard let imageURL = thumbnailImageURLString else {
            DispatchQueue.main.async {
                self.image = placeHolder
            }
            return
        }

        RequestImage.shared.setImageFromServerURL(imageURL, placeHolder: placeHolder) { image, isCache in
            DispatchQueue.main.async {
                if isCache {
                    self.image = image
                } else {
                    self.presentImageWithAnimation(image)
                }
            }
        }
    }
}
