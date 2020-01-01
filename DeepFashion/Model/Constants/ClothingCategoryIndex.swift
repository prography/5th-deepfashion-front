//
//  ClothingCategoryIndex.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct ClothingCategoryIndex {
    static let shared = ClothingCategoryIndex()
    static let mainCategory = [1: "Bottom", 2: "Onepiece", 3: "Outer", 4: "Shoes", 5: "Top"]
    static let mainCategoryIndex = ["Top": 0, "Outer": 1, "Bottom": 2, "Shoes": 3, "Onepiece": 0]

    static let subCategory = [
        1: (5, "청바지"),
    ]

    func convertToMainClientIndex(_ index: Int) -> Int {
        guard let _newIndex = ClothingCategoryIndex.mainCategory[index],
            let newIndex = ClothingCategoryIndex.mainCategoryIndex[_newIndex] else { return 0 }
        return newIndex
    }
}
