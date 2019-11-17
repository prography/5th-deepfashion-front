//
//  APIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

/// API UserData Format
struct UserAPIPostData: Encodable {
    let userName: String
    let gender: String
    let styles: [Int]
    let password: String

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case gender, styles, password
    }
}
