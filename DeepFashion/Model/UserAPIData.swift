//
//  UserAPIGetData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/13.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

// MARK: - Welcome

struct UserAPIData: Codable {
    let username, gender: String
    let styles: [Style]
}

// MARK: - Style

struct Style: Codable {
    let id: Int
    let name: String
}
