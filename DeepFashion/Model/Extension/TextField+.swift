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

    func checkValidPassword() -> Bool {
        guard let nowTextLength = self.text?.count else { return false }
        if nowTextLength >= UserDataRule.Password.minLength, nowTextLength != 0 {
            configureValidStatus()
            return true
        } else {
            configureInvalidStatus()
            return false
        }
    }

    func checkValidId() -> Bool {
        guard let nowTextLength = self.text?.count else { return false }
        if nowTextLength >= UserDataRule.Id.minLength, nowTextLength != 0 {
            configureValidStatus()
            return true
        } else {
            configureInvalidStatus()
            return false
        }
    }

    func checkEqualToOriginPasword(originText text: String) -> Bool {
        guard var nowText = self.text else { return false }
        while nowText.count > UserDataRule.Password.maxLength { nowText.removeLast() }
        if nowText == text, !text.isEmpty {
            configureValidStatus()
            print("true")
            return true
        } else {
            configureInvalidStatus()
            print("false")
            return false
        }
    }

    func configureBasicTextField() {
        borderStyle = .roundedRect
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
