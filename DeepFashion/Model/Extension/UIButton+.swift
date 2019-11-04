//
//  UIButton+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIButton {
    func configureDisabledButton() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        setTitleColor(.black, for: .normal)
        backgroundColor = .gray
        layer.cornerRadius = 6
    }

    func configureSelectedButton() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 6
    }

    func configureButtonByStatus(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        if isEnabled {
            configureSelectedButton()
        } else {
            configureDisabledButton()
        }
    }
}
