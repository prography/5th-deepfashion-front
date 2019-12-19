//
//  FashionStyle.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct FashionStyle {
    static let male = ["Casual", "Formal", "Street", "Vintage", "Sporty", "Dandy"]
    static let female = ["Casual", "Formal", "Street", "Vintage", "Sporty", "Lovely", "Luxury", "Sexy", "Modern", "Purity"]
    static let dictionary: [String: Int] = ["Dandy": 1, "Vintage": 2, "Sexy": 3, "Purity": 4, "Lovely": 5, "Luxury": 6, "Modern": 7, "Formal/Office": 8, "Sporty": 9, "Street": 10, "Casual": 11]
}
