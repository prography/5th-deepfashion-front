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
        layer.borderColor = ColorList.beige?.cgColor
        setTitleColor(.white, for: .normal)
        backgroundColor = ColorList.lightPeach
        alpha = 0.77
        layer.cornerRadius = 10
        isEnabled = false
    }

    func configureEnabledButton() {
        layer.borderColor = ColorList.brownish?.cgColor
        setTitleColor(.white, for: .normal)
        backgroundColor = ColorList.newBrown
        layer.cornerRadius = 10
        alpha = 1.0
        isEnabled = true
    }

    func configureButtonByStatus(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        if isEnabled {
            configureEnabledButton()
        } else {
            configureDisabledButton()
        }
    }

    func configureBasicButton(title: String, fontSize: CGFloat) {
        layer.borderColor = ColorList.beige?.cgColor
        backgroundColor = .white
        layer.cornerRadius = 10
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.mainFont(displaySize: fontSize)
    }
}
