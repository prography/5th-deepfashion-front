//
//  UIColor+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/22.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt64, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
