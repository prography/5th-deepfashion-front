//
//  FashionType.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/30.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum FashionType: Int {
    case top = 0
    case outer = 1
    case bottom = 2
    case shoes = 3

    var title: String {
        switch self {
        case .outer: return "Outer"
        case .top: return "Top"
        case .bottom: return "Bottom"
        case .shoes: return "Shoes"
        }
    }
}
