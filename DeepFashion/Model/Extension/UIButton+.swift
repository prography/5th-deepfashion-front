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
        layer.borderColor = UIColor.darkGray.cgColor
        setTitleColor(.black, for: .normal)
        backgroundColor = .gray
        isEnabled = false
    }

    func configureSelectedButton() {
        layer.borderColor = UIColor.darkGray.cgColor
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        isEnabled = true
    }

    func configureButtonByStatus(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        if isEnabled {
            configureSelectedButton()
        } else {
            configureDisabledButton()
        }
    }

    func configureBasicButton(title: String, fontSize: CGFloat) {
        backgroundColor = .black
        layer.cornerRadius = 5
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.mainFont(displaySize: fontSize)
    }
}
