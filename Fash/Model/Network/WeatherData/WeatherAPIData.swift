//
//  WeatherAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/31.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

// MARK: - WeatherAPIData

struct WeatherAPIData: Codable {
    let id: Int?
    let longitude, latitude: String?
    let weatherID: Int?
    let weatherMain, weatherDescription, weatherIcon, temperature: String?
    let feelsLike, pressure, humidity, windSpeed: String?
    let windDirection, cloud: String?
    let rainOneHour, rainThreeHour, snowOneHour, snowThreeHour: String?
    let calculationDatatime: String?
    let cityCountry: String?
    let cityID: Int?
    let cityName: String?
    let updatedTime: String?

    enum CodingKeys: String, CodingKey {
        case id, longitude, latitude
        case weatherID = "weather_id"
        case weatherMain = "weather_main"
        case weatherDescription = "weather_description"
        case weatherIcon = "weather_icon"
        case temperature
        case feelsLike = "feels_like"
        case pressure, humidity
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case cloud
        case rainOneHour = "rain_one_hour"
        case rainThreeHour = "rain_three_hour"
        case snowOneHour = "snow_one_hour"
        case snowThreeHour = "snow_three_hour"
        case calculationDatatime = "calculation_datatime"
        case cityCountry = "city_country"
        case cityID = "city_id"
        case cityName = "city_name"
        case updatedTime = "updated_time"
    }
}

//typealias WeatherAPIDataList = [WeatherAPIData]
// struct WeatherAPIData: Codable {
//    let id: Int
//    let location: String?
//    let status: String?
//    let temperature: String?
//    let rain: String?
//    let snow: String?
//    let humidity: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, location, rain, snow, humidity, status
//        case temperature = "temp"
//    }
// }
