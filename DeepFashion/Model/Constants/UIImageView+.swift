//
//  UIImageView+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIImageView {
    func setThumbnailImageFromServerURL(_ thumbnailImageURLString: String?, placeHolder: UIImage) {
        guard let imageURL = thumbnailImageURLString else {
            DispatchQueue.main.async {
                self.image = placeHolder
            }
            return
        }

        RequestImage.shared.setImageFromServerURL(imageURL, placeHolder: placeHolder) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
