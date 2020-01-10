//
//  WeatherAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/31.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct WeatherAPIData: Codable {
    let id: Int
    let location: String
    let temperature: String
    let rain: String?
    let snow: String?

    enum CodingKeys: String, CodingKey {
        case id, location, rain, snow
        case temperature = "temp"
    }
}
