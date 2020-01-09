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

    static let subCategoryList = [
        1: SubCategory(name: "청바지", mainIndex: 3),
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
        32: SubCategory(name: "반팔블라우스", mainIndex: 2),
        33: SubCategory(name: "긴팔셔츠", mainIndex: 0),
        34: SubCategory(name: "반팔셔츠", mainIndex: 0),
        35: SubCategory(name: "반팔티셔츠", mainIndex: 0),
        36: SubCategory(name: "피케/카라티셔츠", mainIndex: 0),
        37: SubCategory(name: "니트/스웨터", mainIndex: 0),
        38: SubCategory(name: "베스트/조끼", mainIndex: 0),
        39: SubCategory(name: "힐/펌프스", mainIndex: 3),
    ]

//    private(set) var colorIndex
//    color -> deepColorList: [UInt64] // 결정 위치 별 색상의 헥사코드를 정리한다.
//    khaki navy sky dark_beige purple green yellow blue red gray pink brown lime white black orange beige
//
//    style -> deepStyleList: [Int] // 결정 위치 별 스타일의 실제 인덱스를 정리한다.
//    sporty vintage modern formal/office street luxury casual sexy dandy lovely purity
//
//    season -> deepSeasonList: [Int] // 결정 위치 별 시즌의 실제 client 인덱스를 정리한다.
//    summer spring/fall winter All
//
//    category -> deepCategoryList: [Int] // 결정 위치 별 시즌의 카테고리 인덱스를 정리한다.
//    jogger sleeveless tshirt_long sneakers jumper dress_shirt_long top_others long_padding leggings cardigan sandal running_shoes blouse_long tshirt_short long_boots blazer slacks dress_shirt_short blouse_short flat_shoes coach_jacket hoody_jacket loafer leather_jacket walker trench_coat dress short_boots skirt sweater hightop jean heel short_padding coat fleece_jacket mtm hoody vest

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
