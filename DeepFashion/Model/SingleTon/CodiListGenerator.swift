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
        for i in clothingDataList.indices {
            let nowIndex = ClothingCategoryIndex.shared.convertToMainClientIndex(clothingDataList[i].part)
            clothingDataLists[nowIndex].append(clothingDataList[i])
        }
    }
    
    func getNowCodiDataSet() -> [ClothingAPIData?] {
        for i in topCodiDataSet.indices {
            guard let nowClothingData = clothingDataLists[i].first else {
                topCodiDataSet[i] = nil
                continue
            }
            topCodiDataSet[i] = nowClothingData
        }
        return topCodiDataSet
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

    private init() {}
}
