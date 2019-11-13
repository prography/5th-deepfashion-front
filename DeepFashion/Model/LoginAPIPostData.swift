//
//  loginAPIPostData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/13.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct LoginAPIPostData: Encodable {
    let userName: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case password
    }
}
