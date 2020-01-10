//
//  UIFont+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/25.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIFont {
    static func mainFont(displaySize: CGFloat) -> UIFont {
        if let mainFont = UIFont(name: "S-CoreDream-5Medium", size: displaySize) {
            return mainFont
        }
        return UIFont()
    }

    static func titleFont(displaySize: CGFloat) -> UIFont {
        if let titleFont = UIFont(name: "S-CoreDream-2ExtraLight", size: displaySize) {
            return titleFont
        }
        return UIFont()
    }

    static func subFont(displaySize: CGFloat) -> UIFont {
        if let subFont = UIFont(name: "S-CoreDream-3Light", size: displaySize) {
            return subFont
        }
        return UIFont()
    }
}
