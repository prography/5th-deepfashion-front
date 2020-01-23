//
//  WeatherAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/31.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

typealias WeatherAPIDataList = [WeatherAPIData]
struct WeatherAPIData: Codable {
    let id: Int
    let location: String?
    let status: String?
    let temperature: String?
    let rain: String?
    let snow: String?
    let humidity: String?

    enum CodingKeys: String, CodingKey {
        case id, location, rain, snow, humidity, status
        case temperature = "temp"
    }
}
