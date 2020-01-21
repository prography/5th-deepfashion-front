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
    case cloudy

    var iconImage: UIImage {
        switch self {
        case .sunny:
            return #imageLiteral(resourceName: "clear-day")
        case .rainy:
            return #imageLiteral(resourceName: "rain")
        case .snowy:
            return #imageLiteral(resourceName: "snow")
        case .cloudy:
            return #imageLiteral(resourceName: "partly-cloudy-day")
        }
    }

    var backgroundImage: UIImage {
        switch self {
        case .sunny:
            return #imageLiteral(resourceName: "sunnyBG")
        case .rainy:
            return #imageLiteral(resourceName: "rainyBG")
        case .snowy:
            return #imageLiteral(resourceName: "snowyBG")
        case .cloudy:
            return #imageLiteral(resourceName: "sunnyCloudyBG")
        }
    }
}
