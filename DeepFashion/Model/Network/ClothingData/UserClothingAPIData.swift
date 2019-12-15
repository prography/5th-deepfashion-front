//
//  UserClothingAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/28.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - UserClothingAPIData /clothing/ Post Form Structure

import UIKit

struct UserClothingAPIData: Encodable {
    let style: Int
    let name: String
    let color: String
    let owner: Int
    let season: Int
    let part: Int
    let images: [Int]
    enum CodingKeys: String, CodingKey {
        case style, name, color, owner, season, part, images
    }
}
