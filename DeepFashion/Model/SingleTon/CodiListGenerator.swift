//
//  CodiListPicker.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/03.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

final class CodiListGenerator {
    static let shared = CodiListGenerator()

    private(set) var clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)

    func getClothingDataList(_ clothingDataList: [ClothingAPIData]) {
        for i in clothingDataList.indices {
            let nowIndex = ClothingCategoryIndex.shared.convertToMainClientIndex(clothingDataList[i].part)
            clothingDataLists[nowIndex].append(clothingDataList[i])
        }
    }

    private init() {}
}
