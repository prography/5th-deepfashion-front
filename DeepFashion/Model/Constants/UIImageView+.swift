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
            return
        }

        DispatchQueue.main.async {
            RequestImage.shared.setImageFromServerURL(imageURL, placeHolder: placeHolder) { image in
                self.image = image
            }
        }
    }
}
