//
//  UserTokenData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/13.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UserTokenAPIData: Codable {
    let token: String

    enum CodingKeys: CodingKey {
        case token
    }
}
