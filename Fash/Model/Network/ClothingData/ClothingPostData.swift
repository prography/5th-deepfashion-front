//
//  UserClothingAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/28.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

// MARK: - UserClothingAPIData /clothing/ Post Form Structure

import UIKit

struct ClothingPostData {
    let id: Int?
    let name: String
    let style: Int
    let owner: Int
    let color: Int
    let season: Int
    let part: Int
    let category: Int
    let image: UIImage?
}
