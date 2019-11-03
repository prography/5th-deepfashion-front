//
//  Constants.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UIIdentifier {
    static let mainView = "mainView"
    static let mainNavigationController = "MainNavigationController"
}

struct SegueIdentifier {
    static let goToFirstSignUp = "goToFirstSignUp"
    static let goToSecondSignUp = "goToSecondSignUp"
    static let unwindToMain = "unwindToMain"
}

struct MyCharacterSet {
    static let signUp = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
}

struct UserDataRule {
    struct Id {
        static let minLength = 6
        static let maxLength = 10
    }

    struct Password {
        static let minLength = 8
        static let maxLength = 10
    }
}
