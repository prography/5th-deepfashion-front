//
//  TextField+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UITextField {
    func configureInvalidStatus() {
        layer.borderColor = UIColor.red.cgColor
    }

    func configureValidStatus() {
        layer.borderColor = UIColor.blue.cgColor
    }

    func checkValidPassword() {
        guard let nowTextLength = self.text?.count else { return }
        if nowTextLength != 0 {
            if nowTextLength >= UserDataRule.Password.minLength, nowTextLength <= UserDataRule.Password.maxLength {
                configureValidStatus()
            } else {
                configureInvalidStatus()
            }
        }
    }

    func checkValidId() {
        guard let nowTextLength = self.text?.count else { return }
        if nowTextLength != 0 {
            if nowTextLength >= UserDataRule.Id.minLength, nowTextLength <= UserDataRule.Id.maxLength {
                configureValidStatus()
            } else {
                configureInvalidStatus()
            }
        }
    }

    func checkEqualToOriginPasword(originText text: String) {
        guard let nowText = self.text else { return }
        if !nowText.isEmpty {
            if nowText == text { configureValidStatus() }
            else { configureInvalidStatus() }
        }
    }

    func configureBasicTextField() {
        borderStyle = .roundedRect
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
