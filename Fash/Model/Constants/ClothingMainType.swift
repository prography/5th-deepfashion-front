//
//  FashionType.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/30.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum ClothingMainType: Int {
    case top = 0
    case outer = 1
    case bottom = 2
    case shoes = 3

    var title: String {
        switch self {
        case .outer: return "OUTER"
        case .top: return "TOP"
        case .bottom: return "BOTTOM"
        case .shoes: return "SHOES"
        }
    }
}
