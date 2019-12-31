//
//  WeatherIndex.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/31.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum WeatherIndex {
    case sunny
    case rainy
    case snowy

    var image: UIImage {
        switch self {
        case .sunny:
            return #imageLiteral(resourceName: "clear-day")
        case .rainy:
            return #imageLiteral(resourceName: "rain")
        case .snowy:
            return #imageLiteral(resourceName: "snow")
        }
    }
}
