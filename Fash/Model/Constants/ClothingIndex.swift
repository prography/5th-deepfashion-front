//
//  ClothingCategoryIndex.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct SubClothingCategory {
    var name: String
    var mainIndex: Int
}

typealias SubCategory = SubClothingCategory

struct ClothingIndex {
    static let shared = ClothingIndex()
    static let mainServerCategoryList = [1: "Bottom", 2: "Onepiece", 3: "Outer", 4: "Shoes", 5: "Top"]
    static let mainClientCategoryList = [0: "Top", 1: "Outer", 2: "Bottom", 3: "Shoes", 4: "Onepiece"]
    static let mainCategoryClientIndex = ["Top": 0, "Outer": 1, "Bottom": 2, "Shoes": 3, "Onepiece": 4]
    static let mainCategoryServerIndex = ["Top": 5, "Outer": 3, "Bottom": 1, "Shoes": 4, "Onepiece": 2]
    static let seasonServerIndex: [SeasonIndex: Int] = [.all: 1, .springFall: 2, .summer: 3, .winter: 4]

    static let subCategoryList = [
        1: SubCategory(name: "청바지", mainIndex: 2),
        2: SubCategory(name: "조거팬츠", mainIndex: 2),
        3: SubCategory(name: "슬랙스/수트팬츠", mainIndex: 2),
        4: SubCategory(name: "롱패딩", mainIndex: 1),
        5: SubCategory(name: "숏패딩", mainIndex: 1),
        6: SubCategory(name: "코트", mainIndex: 1),
        7: SubCategory(name: "트렌치코트", mainIndex: 1),
        8: SubCategory(name: "블레이저자켓", mainIndex: 1),
        9: SubCategory(name: "후드집업/후드자켓", mainIndex: 1),
        10: SubCategory(name: "플리스자켓", mainIndex: 1),
        11: SubCategory(name: "트러커/코치자켓", mainIndex: 1),
        12: SubCategory(name: "블루종/항공점퍼/스타디움자켓", mainIndex: 1),
        13: SubCategory(name: "가죽자켓", mainIndex: 1),
        14: SubCategory(name: "가디건", mainIndex: 1),
        15: SubCategory(name: "원피스", mainIndex: 0),
        16: SubCategory(name: "플랫슈즈", mainIndex: 3),
        17: SubCategory(name: "로퍼", mainIndex: 3),
        18: SubCategory(name: "롱부츠", mainIndex: 3),
        19: SubCategory(name: "숏부츠", mainIndex: 3),
        20: SubCategory(name: "워커", mainIndex: 3),
        21: SubCategory(name: "스니커즈", mainIndex: 3),
        22: SubCategory(name: "러닝화", mainIndex: 3),
        23: SubCategory(name: "샌들", mainIndex: 3),
        24: SubCategory(name: "후드스웨트셔츠", mainIndex: 0),
        25: SubCategory(name: "맨투맨/스웨트셔츠", mainIndex: 0),
        26: SubCategory(name: "민소매", mainIndex: 0),
        27: SubCategory(name: "크롭탑", mainIndex: 0),
        28: SubCategory(name: "긴팔티셔츠", mainIndex: 0),
        29: SubCategory(name: "레깅스", mainIndex: 2),
        30: SubCategory(name: "치마", mainIndex: 2),
        31: SubCategory(name: "긴팔블라우스", mainIndex: 0),
        32: SubCategory(name: "반팔블라우스", mainIndex: 0),
        33: SubCategory(name: "긴팔셔츠", mainIndex: 0),
        34: SubCategory(name: "반팔셔츠", mainIndex: 0),
        35: SubCategory(name: "반팔티셔츠", mainIndex: 0),
        36: SubCategory(name: "피케/카라티셔츠", mainIndex: 0),
        37: SubCategory(name: "니트/스웨터", mainIndex: 0),
        38: SubCategory(name: "베스트/조끼", mainIndex: 0),
        39: SubCategory(name: "힐/펌프스", mainIndex: 3),
    ]

    // deepLearning Index Matching작업 중

    // MARK: - DeepLearning Color

    //    color -> deepColorList: [UInt64] // 결정 위치 별 색상의 헥사코드를 정리한다.
    //    khaki navy sky dark_beige purple
    //    green yellow blue red gray
    //    pink brown lime white black
    //    orange beige

    static let deepColorList: [UInt64] = [
        0x708238, 0x1B4872, 0x00B0FF, 0x704301, 0x863C9C,
        0x047949, 0xFFD700, 0x1C7ED6, 0xEE220C, 0xA9A9A9,
        0xF783AD, 0xB46A22, 0xC7EA46, 0xFFFFFA, 0x000000,
        0xFF5700, 0xF7F1E0,
    ]

    // MARK: - DeepLearning Style

//    style -> deepStyleList: [Int] // 결정 위치 별 스타일의 실제 인덱스를 정리한다.
//    sporty vintage modern formal/office street
//    luxury casual sexy dandy lovely
//    purity

    static let deepStyleList: [Int] = [
        3, 10, 5, 4, 2,
        6, 1, 9, 11, 7,
        8,
    ]

    // MARK: - DeepLearning Season

//    season -> deepSeasonList: [Int] // 결정 위치 별 시즌의 실제 client

    static let deepSeasonList: [Int] = [
        2, 1, 3, 0,
    ]

    // MARK: - DeepLearning Category

//    jogger sleeveless tshirt_long sneakers jumper dress_shirt_long top_others long_padding leggings cardigan sandal running_shoes blouse_long tshirt_short long_boots blazer slacks dress_shirt_short blouse_short flat_shoes coach_jacket hoody_jacket loafer leather_jacket walker trench_coat dress short_boots skirt sweater hightop jean heel short_padding coat fleece_jacket mtm hoody vest
    static let deepCategoryList: [Int] = [
        2, 26, 28, 21, 12,
        33, 36, 4, 29, 14,
        23, 22, 31, 35, 18,
        8, 3, 34, 32, 16,
        11, 9, 17, 13, 20,
        7, 15, 19, 30, 37,
        27, 1, 39, 5, 6,
        10, 25, 24, 38,
    ]

    func convertToMainClientIndex(_ index: Int) -> Int {
        guard let _newIndex = ClothingIndex.mainServerCategoryList[index],
            var newIndex = ClothingIndex.mainCategoryClientIndex[_newIndex] else { return 0 }
        newIndex = newIndex == 4 ? 0 : newIndex
        return newIndex
    }

//    func convertToMainClientIndex(_ index: String) -> Int {
//        guard let _newIndex = ClothingCategoryIndex.mainCategoryList[index],
//            let newIndex = ClothingCategoryIndex.mainCategoryClientIndex[_newIndex] else { return 0 }
//        return newIndex
//    }

    func convertToMainServerIndex(_ typeName: String) -> Int {
        guard let newIndex = ClothingIndex.mainCategoryServerIndex[typeName] else { return 0 }
        return newIndex
    }

    func getMainCategoryName(_ index: Int) -> String {
        if index < 0 { return "Top" }
        guard let newIndex = ClothingIndex.mainClientCategoryList[index] else { return "Top" }
        return newIndex
    }
}
