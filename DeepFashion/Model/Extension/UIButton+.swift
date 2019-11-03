//
//  UIButton+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIButton {
    func configureBasicButton() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        backgroundColor = .lightGray
        layer.cornerRadius = 6
    }

    func configureSelectedButton() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        backgroundColor = .black
        layer.cornerRadius = 6
    }
}
