//
//  ClothingAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct ClothingAPIData: Codable, Hashable, Comparable {
    static func == (lhs: ClothingAPIData, rhs: ClothingAPIData) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: ClothingAPIData, rhs: ClothingAPIData) -> Bool {
        return lhs.id < rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    let id: Int
    let name: String
    let image: String?
    let style: Int
    let owner: Int
    let color: Int
    let season: Int
    let part: Int
    let category: Int

    enum CodingKeys: String, CodingKey {
        case id, name, style, owner, color, season, part, category
        case image = "img"
    }
}

typealias ClothingAPIDataList = [ClothingAPIData]
