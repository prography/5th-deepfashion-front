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
    private(set) var topCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)

    func configureClothingDataList(_ clothingDataList: [ClothingAPIData]) {
        resetData()
        for i in clothingDataList.indices {
            guard let nowIndex = ClothingCategoryIndex.subCategoryList[clothingDataList[i].category]?.mainIndex else { continue }
            clothingDataLists[nowIndex].append(clothingDataList[i])
        }
    }

    func getNowCodiDataSet(_ clothingDataList: [ClothingAPIData]) {
        configureClothingDataList(clothingDataList)

        for i in topCodiDataSet.indices {
            guard let nowClothingData = clothingDataLists[i].first else {
                topCodiDataSet[i] = nil
                continue
            }
            topCodiDataSet[i] = nowClothingData
        }
    }

    func getNextCodiDataSet(_ fixTypeStatus: [Int]) -> [ClothingAPIData?] {
        for i in topCodiDataSet.indices {
            if clothingDataLists[i].isEmpty {
                topCodiDataSet[i] = nil
            } else {
                if fixTypeStatus[i] == 1 {
                    clothingDataLists[i].removeFirst()
                    guard let nowClothingData = clothingDataLists[i].first else {
                        topCodiDataSet[i] = nil
                        continue
                    }

                    topCodiDataSet[i] = nowClothingData
                    clothingDataLists[i].append(nowClothingData)
                } else {
                    guard let nowClothingData = clothingDataLists[i].first else {
                        topCodiDataSet[i] = nil
                        continue
                    }
                    topCodiDataSet[i] = nowClothingData
                }
            }
        }
        return topCodiDataSet
    }

    func resetData() {
        clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        topCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    }

    private init() {}
}
