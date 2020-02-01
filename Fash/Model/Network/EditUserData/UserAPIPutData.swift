//
//  UserAPIPutData.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/02/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

/// API Put UserData Format
struct UserAPIPutData: Codable {
    let userName: String
    let gender: String
    let styles: [Int]
    let password: String

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case gender, styles, password
    }
}
