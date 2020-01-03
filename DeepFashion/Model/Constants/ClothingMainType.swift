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
        case .outer: return "아우터"
        case .top: return "상의"
        case .bottom: return "하의"
        case .shoes: return "신발"
        }
    }
}
