//
//  SelectedFashionData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct FashionData {
    var image: UIImage?
    var style: (String, Int)
    var typeIndex = 0
    var weatherIndex = 0
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
