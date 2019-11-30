//
//  FashionType.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/30.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum FashionType: String {
    case outer = "Outer"
    case top = "Top"
    case bottom = "Bottom"
    case shoes = "Shoes"
    
    var title: String {
        switch self {
            case .outer: return "Outer"
            case .top: return "Top"
            case .bottom: return "Bottom"
            case .shoes: return "Shoes"
        }
    }
}
