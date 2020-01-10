//
//  SelectedFashionData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct ClothingData {
    var image: UIImage?
    var style: (String, Int)
    var typeIndex = 0
    var seasonIndex = 0
    var categoryIndex: (Int, SubCategory) = (1, ClothingIndex.subCategoryList[1] ?? SubCategory(name: "청바지", mainIndex: 3))
    var colorIndex: UInt64 = 0x000000
    var gender = UserCommonData.shared.gender
    init() {
        var styleName: [String] = []
        if gender == 0 {
            styleName = ClothingStyle.male
        } else {
            styleName = ClothingStyle.female
        }

        style = (styleName[0], 0)
    }
}
