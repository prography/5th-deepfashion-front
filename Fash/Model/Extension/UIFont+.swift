//
//  UIFont+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/25.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIFont {
    static func mainFont(displaySize _: CGFloat) -> UIFont {
//        if let mainFont = UIFont(name: "AppleSDGothicNeo-Regular", size: displaySize) {
//            return mainFont
//        }
        return UIFont()
    }

    static func titleFont(displaySize _: CGFloat) -> UIFont {
//        if let titleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: displaySize) {
//            return titleFont
//        }
        return UIFont()
    }

    static func subFont(displaySize: CGFloat) -> UIFont {
        if let subFont = UIFont(name: "AppleSDGothicNeo-Thin", size: displaySize) {
            return subFont
        }
        return UIFont()
    }
}
