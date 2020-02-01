//
//  LocationAPIDate.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/02/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

struct LocationAPIData: Codable {
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}
