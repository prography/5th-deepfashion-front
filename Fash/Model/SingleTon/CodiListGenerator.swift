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

    private(set) var topRecommendedCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    private(set) var seasonIndex = SeasonIndex.all
    private(set) var weatherDataDidAdjusted = false

    func configureClothingDataLists() {
        resetData()
        for i in CommonUserData.shared.clothingDataList.indices {
            guard let nowIndex = ClothingIndex.subCategoryList[CommonUserData.shared.clothingDataList[i].category]?.mainIndex else { continue }
            clothingDataLists[nowIndex].append(CommonUserData.shared.clothingDataList[i])
        }

        // 코디리스트 추천 알고리즘 적용
        classifyCodiList()
    }

    private func classifyCodiList() {
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
            recommendedClothingDataLists[i] = seasonClassifiedClothingDataLists[i].shuffled() + otherClassifiedClothingDataLists[i].shuffled()
        }

        debugPrint("seasonClassifiedClothingDataLists : \(seasonClassifiedClothingDataLists)")
        debugPrint("otherClassifiedClothingDataLists : \(otherClassifiedClothingDataLists)")
        debugPrint("recommendedClothingDataLists : \(recommendedClothingDataLists)")
    }

    func resetCodiListGenerator() {
        clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        topRecommendedCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
        weatherDataDidAdjusted = false
    }

    func getNowCodiDataSet() {
        configureClothingDataLists()

        for i in topRecommendedCodiDataSet.indices {
            guard let recommendedClothingData = recommendedClothingDataLists[i].first else {
                topRecommendedCodiDataSet[i] = nil
                continue
            }
            topRecommendedCodiDataSet[i] = recommendedClothingData
        }
    }

    func getNextCodiDataSet(_ fixTypeStatus: [Int]) {
        for i in topRecommendedCodiDataSet.indices {
            if recommendedClothingDataLists[i].isEmpty {
                topRecommendedCodiDataSet[i] = nil
            } else {
                if fixTypeStatus[i] == 1 {
                    guard let nowClothingData = recommendedClothingDataLists[i].first else {
                        topRecommendedCodiDataSet[i] = nil
                        continue
                    }
                    recommendedClothingDataLists[i].removeFirst()
                    recommendedClothingDataLists[i].append(nowClothingData)
                    topRecommendedCodiDataSet[i] = nowClothingData

                } else {
                    continue
                }
            }
        }
    }

    private func resetData() {
        clothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        seasonClassifiedClothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        otherClassifiedClothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        recommendedClothingDataLists = [[ClothingAPIData]](repeating: [ClothingAPIData](), count: 4)
        topRecommendedCodiDataSet = [ClothingAPIData?](repeating: nil, count: 4)
    }

    private init() {}
}
