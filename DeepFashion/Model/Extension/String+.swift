//
//  String+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 04/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension String {
    func isAlphabetNumeric() -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        let isAlphabet = rangeOfCharacter(from: alphabetSet) != nil
        let isNumeric = rangeOfCharacter(from: numberSet) != nil

        return !isEmpty && isAlphabet && isNumeric
    }

    func isAlphabetPrefix() -> Bool {
        let textArray = Array(self)
        guard let firstCharacter = textArray.first else { return false }
        if textArray.count != 0, firstCharacter.isLetter {
            return true
        } else {
            return false
        }
    }
}
