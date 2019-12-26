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

    func checkValidId() -> Bool {
        guard var nowText = self.text else { return false }
        while nowText.count > UserDataRule.Common.maxLength { nowText.removeLast() }
        if nowText.count >= UserDataRule.Id.minLength, nowText.count != 0, nowText.isAlphabetPrefix() {
            configureValidStatus()
            return true
        } else {
            configureInvalidStatus()
            return false
        }
    }

    func checkValidPassword() -> Bool {
        guard var nowText = self.text else { return false }
        while nowText.count > UserDataRule.Common.maxLength { nowText.removeLast() }
        if nowText.count >= UserDataRule.Password.minLength, nowText.count != 0, nowText.isAlphabetNumeric() {
            configureValidStatus()
            return true
        } else {
            configureInvalidStatus()
            return false
        }
    }

    func checkEqualToOriginPasword(originText text: String) -> Bool {
        guard var nowText = self.text else { return false }
        while nowText.count > UserDataRule.Common.maxLength { nowText.removeLast() }
        if nowText == text, !text.isEmpty, nowText.isAlphabetNumeric() {
            configureValidStatus()
            return true
        } else {
            configureInvalidStatus()
            return false
        }
    }

    func configureBasicTextField() {
        borderStyle = .roundedRect
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = ViewData.Color.borderColor
    }
}
