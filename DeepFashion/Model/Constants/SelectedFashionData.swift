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
    var style = [(String, Int)]()
    var typeIndex = 0
    var weatherIndex: Set<Int> = [0]
}
