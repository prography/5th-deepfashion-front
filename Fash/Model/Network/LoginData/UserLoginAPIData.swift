//
//  UserTokenData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/13.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UserLoginAPIData: Decodable {
    let token: String
    let pk: Int
}
