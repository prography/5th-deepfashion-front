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

    func configureClothingDataList() {
        resetData()
        for i in UserCommonData.shared.clothingDataList.indices {
            guard let nowIndex = ClothingIndex.subCategoryList[UserCommonData.shared.clothingDataList[i].category]?.mainIndex else { continue }
            clothingDataLists[nowIndex].append(UserCommonData.shared.clothingDataList[i])
        }
    }
    
    func resetCodiListGenerator() {
        clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        topCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    }

    func getNowCodiDataSet() {
        configureClothingDataList()

        for i in topCodiDataSet.indices {
            guard let nowClothingData = clothingDataLists[i].first else {
                topCodiDataSet[i] = nil
                continue
            }
            topCodiDataSet[i] = nowClothingData
        }
    }

    func getNextCodiDataSet(_ fixTypeStatus: [Int]) {
        for i in topCodiDataSet.indices {
            if clothingDataLists[i].isEmpty {
                topCodiDataSet[i] = nil
            } else {
                if fixTypeStatus[i] == 1 {
                    guard let nowClothingData = clothingDataLists[i].first else {
                        topCodiDataSet[i] = nil
                        continue
                    }
                    clothingDataLists[i].removeFirst()
                    clothingDataLists[i].append(nowClothingData)
                    topCodiDataSet[i] = nowClothingData

                } else {
                    continue
                }
            }
        }
//        return topCodiDataSet
    }

    func resetData() {
        clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        topCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    }

    private init() {}
}
