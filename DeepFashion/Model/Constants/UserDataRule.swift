//
//  UserDataRule.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

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
