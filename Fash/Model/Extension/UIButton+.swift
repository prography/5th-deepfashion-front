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
        setTitleColor(ColorList.loginButtonDisabledTitle, for: .normal)
        backgroundColor = ColorList.loginButtonDisabledBG
        layer.cornerRadius = 10
        isEnabled = false
    }

    func configureEnabledButton() {
        setTitleColor(ColorList.loginButtonEnabledTitle, for: .normal)
        backgroundColor = ColorList.loginButtonEnabledBG
        layer.cornerRadius = 10
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
        layer.borderColor = ColorList.mainBorder
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.mainFont(displaySize: fontSize)
    }

    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }

        let totalHeight = imageViewSize.height + titleLabelSize.height + padding

        imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: frame.size.width / 2 - imageViewSize.width / 2,
            bottom: 0.0,
            right: 0.0
        )

        titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )

        contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )

        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.center.x = titleLabel.center.x
        }
    }

//    @objc func isButtonTouchEvent(_ sender: Any) {
//        if let imageView = self.imageView, let titleLabel = self.titleLabel {
//            imageView.center.x = titleLabel.center.x
//        }
//    }
}
