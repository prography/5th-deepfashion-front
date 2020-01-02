//
//  FashionStyle.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct ClothingStyle {
    static let male = ["Casual", "Formal", "Street", "Vintage", "Sporty", "Dandy"]
    static let female = ["Casual", "Formal", "Street", "Vintage", "Sporty", "Lovely", "Luxury", "Sexy", "Modern", "Purity"]
    static let dictionary: [String: Int] = ["Casual": 1, "Street": 2, "Sporty": 3, "Formal": 4, "Modern": 5, "Luxury": 6, "Lovely": 7, "Purity": 8, "Sexy": 9, "Vintage": 10, "Dandy": 11]
}
