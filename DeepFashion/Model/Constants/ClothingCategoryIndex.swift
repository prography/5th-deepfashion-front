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

struct ClothingCategoryIndex {
    static let shared = ClothingCategoryIndex()
    static let mainCategoryList = [1: "Bottom", 2: "Onepiece", 3: "Outer", 4: "Shoes", 5: "Top"]
    static let mainCategoryClientIndex = ["Top": 0, "Outer": 1, "Bottom": 2, "Shoes": 3, "Onepiece": 0]
    static let mainCategoryServerIndex = ["Top": 5, "Outer": 4, "Bottom": 1, "Shoes": 4, "Onepiece": 2]

    static let subCategoryList = [
        1: SubCategory(name: "청바지", mainIndex: 0),
        2: SubCategory(name: "츄리닝", mainIndex: 2),
        3: SubCategory(name: "슬랙스", mainIndex: 2),
        4: SubCategory(name: "롱패딩", mainIndex: 1),
        5: SubCategory(name: "숏패딩", mainIndex: 1),
        6: SubCategory(name: "코트", mainIndex: 1),
        7: SubCategory(name: "트렌치 코트", mainIndex: 1),
        8: SubCategory(name: "자켓", mainIndex: 1),
        9: SubCategory(name: "후드자켓", mainIndex: 1),
        10: SubCategory(name: "후리스", mainIndex: 1),
        11: SubCategory(name: "코치자켓", mainIndex: 1),
        12: SubCategory(name: "점퍼", mainIndex: 1),
        13: SubCategory(name: "가죽자켓", mainIndex: 1),
        14: SubCategory(name: "가디건", mainIndex: 1),
        15: SubCategory(name: "드레스", mainIndex: 0),
        16: SubCategory(name: "플랫슈즈", mainIndex: 3),
        17: SubCategory(name: "로퍼", mainIndex: 3),
        18: SubCategory(name: "롱부츠", mainIndex: 3),
        19: SubCategory(name: "숏부츠", mainIndex: 3),
        20: SubCategory(name: "워커", mainIndex: 3),
        21: SubCategory(name: "스니커즈", mainIndex: 3),
        22: SubCategory(name: "운동화", mainIndex: 3),
        23: SubCategory(name: "샌들", mainIndex: 3),
        24: SubCategory(name: "후드티", mainIndex: 0),
        25: SubCategory(name: "MTM", mainIndex: 0),
        26: SubCategory(name: "민소매", mainIndex: 0),
        27: SubCategory(name: "하이탑", mainIndex: 0),
        28: SubCategory(name: "긴팔티셔츠", mainIndex: 0),
        29: SubCategory(name: "레깅스", mainIndex: 2),
        30: SubCategory(name: "치마", mainIndex: 2),
        31: SubCategory(name: "긴팔블라우스", mainIndex: 0),
        32: SubCategory(name: "반팔블라우스", mainIndex: 2),
        33: SubCategory(name: "긴팔드레스셔츠", mainIndex: 0),
        34: SubCategory(name: "반팔드레스셔츠", mainIndex: 0),
        35: SubCategory(name: "반팔티셔츠", mainIndex: 0),
        36: SubCategory(name: "상의(기타)", mainIndex: 0),
        37: SubCategory(name: "스웨터", mainIndex: 0),
        38: SubCategory(name: "조끼", mainIndex: 0),
        39: SubCategory(name: "하이힐", mainIndex: 3),
    ]

    func convertToMainClientIndex(_ index: Int) -> Int {
        guard let _newIndex = ClothingCategoryIndex.mainCategoryList[index],
            let newIndex = ClothingCategoryIndex.mainCategoryClientIndex[_newIndex] else { return 0 }
        return newIndex
    }

//    func convertToMainClientIndex(_ index: String) -> Int {
//        guard let _newIndex = ClothingCategoryIndex.mainCategoryList[index],
//            let newIndex = ClothingCategoryIndex.mainCategoryClientIndex[_newIndex] else { return 0 }
//        return newIndex
//    }

    func convertToMainServerIndex(_ typeName: String) -> Int {
        guard let newIndex = ClothingCategoryIndex.mainCategoryServerIndex[typeName] else { return 0 }
        return newIndex
    }

    func getMainCategoryName(_ index: Int) -> String {
        if index - 1 < 0 { return "Top" }
        guard let newIndex = ClothingCategoryIndex.mainCategoryList[index - 1] else { return "Top" }
        return newIndex
    }
}
