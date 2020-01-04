//
//  AccountsAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/05.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

struct AccountsAPIData: Codable {
    let username, gender: String
    let styles: [Style]
}
