//
//  UIImageView+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIImageView {
    func presentImageWithAnimation(_ image: UIImage, _ duration: CGFloat = 0.23) {
        self.image = image
        alpha = 0.0
        UIView.animate(withDuration: TimeInterval(duration), animations: { [weak self] in
            self?.alpha = 1.0
        })
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
