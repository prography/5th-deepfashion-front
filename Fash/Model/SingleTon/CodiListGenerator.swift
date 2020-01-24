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
    private(set) var seasonClassifiedClothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
    private(set) var otherClassifiedClothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
    private(set) var recommendedClothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)

    private(set) var topCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    private(set) var seasonIndex = SeasonIndex.all

    func configureClothingDataList() {
        resetData()
        for i in CommonUserData.shared.clothingDataList.indices {
            guard let nowIndex = ClothingIndex.subCategoryList[CommonUserData.shared.clothingDataList[i].category]?.mainIndex else { continue }
            clothingDataLists[nowIndex].append(CommonUserData.shared.clothingDataList[i])
        }
    }

    func classifyCodiList() {
        adjustWeatherData()
    }

    private func adjustWeatherData() {
        // ✓ clothingDataLists : 초기 원본 파트 별 옷 데이터 2차원배열 리스트 (파트별 4종류의 list가 존재)
        // ✓ seasonClassifiedClothingDataLists : 현재 계절에 한해서 분류한 옷 데이터 2차원배열 리스트
        // ✓ otherClassifiedClothingDataLists : 현재 계절 이외 옷 데이터 2차원배열 리스트
        // ✓ recommendedClothingDataLists : 실제 코디 추천에 사용 될 2차원배열 리스트

        guard let weatherData = CommonUserData.shared.weatherData else { return }
        if weatherData.temperature <= 5.0 {
            seasonIndex = .winter
        } else if weatherData.temperature <= 23.0 {
            seasonIndex = .springFall
        } else {
            seasonIndex = .summer
        }

        for i in clothingDataLists.indices {
            for j in clothingDataLists[i].indices {
                if clothingDataLists[i][j].season == seasonIndex.rawValue {
                    seasonClassifiedClothingDataLists[i].append(clothingDataLists[i][j])
                } else {
                    otherClassifiedClothingDataLists[i].append(clothingDataLists[i][j])
                }
            }
        }

        for i in recommendedClothingDataLists.indices {
            recommendedClothingDataLists[i] = seasonClassifiedClothingDataLists[i] + otherClassifiedClothingDataLists[i]
        }

        debugPrint("seasonClassifiedClothingDataLists : \(seasonClassifiedClothingDataLists)")
        debugPrint("otherClassifiedClothingDataLists : \(otherClassifiedClothingDataLists)")
        debugPrint("recommendedClothingDataLists : \(recommendedClothingDataLists)")
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
    }

    func resetData() {
        clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        topCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    }

    private init() {}
}
