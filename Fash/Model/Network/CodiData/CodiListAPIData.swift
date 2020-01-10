//
//  CodiAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/06.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct CodiListAPIData: Codable {
    let id: Int?
    let name: String
    let owner: Int
    let clothes: [Int]
    let createdTime: String?
    let updatedTime: String?
    enum CodingKeys: String, CodingKey {
        case id, name, owner, clothes
        case createdTime = "created_at"
        case updatedTime = "update_time"
    }
}
