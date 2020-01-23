//
//  GenderIndex.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/23.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

enum GenderIndex: Int {
    case male = 0
    case female = 1

    var index: String {
        switch self {
        case .male: return "M"
        case .female: return "W"
        }
    }
}
