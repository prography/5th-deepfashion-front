//
//  CodiAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/06.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct CodiAPIData: Codable {
    let name: String
    let owner: Int
    let clothes: [Int]

    enum CodingKeys: String, CodingKey {
        case name, owner, clothes
    }
}
