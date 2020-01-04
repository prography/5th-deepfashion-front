//
//  AccountsAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/05.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

struct AccountCheckAPIData: Codable {
    let username: String
    let gender: String?
    let styles: [Style]?
}
