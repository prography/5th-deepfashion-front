//
//  UserClothingPostAPIResultData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct UserClothingPostAPIResultData: Codable {
    let style: Int
    let name, color: String
    let owner, season, part: Int
    let images: [ClothingSubData]
}

struct ClothingSubData: Codable {
    let id: Int
    let image: String
    let owner, clothing: Int
}
