//
//  ClothingAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct ClothingAPIDataList: Decodable {}

struct ClothingAPIData: Decodable {
    let id: Int
    let name: String
    let image: String?
    let style: Int
    let owner: Int
    let color: Int
    let season: Int
    let part: Int
    let category: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, style, owner, color, season, part, category
        case image = "img"
    }
}
