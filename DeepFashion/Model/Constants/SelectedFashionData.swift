//
//  SelectedFashionData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct SelectedFashionData {
    var image: UIImage?
    var style: [(String, Int)] = []
    var typeIndex = 0
    var weatherIndex: [Int: Int] = [0: 1, 1: 0, 2: 0, 3: 0]
    var gender = CommonUserData.shared.gender
    init() {
        var styleName: [String] = []
        if gender == 0 {
            styleName = FashionStyle.male
        } else {
            styleName = FashionStyle.female
        }

        for i in styleName.indices {
            style.append((styleName[i], 0))
        }

        style[0].1 = 1
    }
}
