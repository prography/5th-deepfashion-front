//
//  UserData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

final class UserCommonData {
    static let shared = UserCommonData()

    private(set) var userData: UserData?
    private(set) var id: String = ""
    private(set) var pk: Int = 0
    private(set) var userToken: String = ""
    private(set) var password: String = ""
    private(set) var gender: Int = 0
    private(set) var isNeedToUpdateClothing = false
    private(set) var selectedStyle = ["Casual": 0, "Formal": 0, "Street": 0, "Vintage": 0, "Hiphop": 0, "Sporty": 0, "Lovely": 0, "Luxury": 0, "Sexy": 0, "Modern": 0, "Chic": 0, "Purity": 0, "Dandy": 0]
    private(set) var nowClothingCode: Int = 0

    private(set) var codiDataList = [CodiDataSet?]()
    private(set) var clothingList = [ClothingAPIData]()
    var thumbnailImageCache = NSCache<NSString, UIImage>()

    private init() {}

    func setUserData(id: String, password: String, gender: Int) {
        self.id = id
        self.password = password
        self.gender = gender
        userData = UserData(userName: id, styles: [], password: password, gender: gender)
        clothingList = [ClothingAPIData]()
    }

    func saveID(_ id: String) {
        self.id = id
    }

    func setUserPrivateData(token: String, pk: Int) {
        userToken = token
        self.pk = pk
    }

    func toggleStyleData(styleName: String) -> Int {
        if selectedStyle[styleName] == 0 {
            selectedStyle[styleName] = 1
        } else {
            selectedStyle[styleName] = 0
        }
        userData?.configureStyle(styles: selectedStyle)
        return selectedStyle[styleName] ?? 0
    }

    func setClothingCode(_ clothingCode: Int) {
        nowClothingCode = clothingCode
    }

    func resetStyleData() {
        selectedStyle = ["Casual": 0, "Formal": 0, "Street": 0, "Vintage": 0, "Hiphop": 0, "Sporty": 0, "Lovely": 0, "Luxury": 0, "Sexy": 0, "Modern": 0, "Chic": 0, "Purity": 0, "Dandy": 0]
        userData?.configureStyle(styles: selectedStyle)
    }

    func resetClothingData() {
        clothingList = [ClothingAPIData]()
    }

    func configureClothingData(_ clothingDataList: [ClothingAPIData]) {
        clothingList = clothingDataList
    }

    func removeClothingData(selectedData _: Set<ClothingAPIData>) {
//        clothingList.sort {
//            $0.id < $1.id
//        }
//
//        for i in selectedData.indices {
//            if let idx = clothingList.binarySearch(searchData: selectedData[i]) {
//                clothingList.remove(at: idx)
//            }
//        }
    }

    func setIsNeedToUpdateClothingTrue() {
        isNeedToUpdateClothing = true
    }

    func setIsNeedToUpdateClothingFalse() {
        isNeedToUpdateClothing = false
    }

    func addCodiData(_ codiData: [CodiData]) {
        let nowTimeStamp = Date().timeIntervalSince1970
        var codiDataSet = CodiDataSet(timeStamp: nowTimeStamp)
        codiDataSet.configureData(dataSet: codiData)
        codiDataList.append(codiDataSet)
    }

    func configureCodiDataList(_ codiDataList: [CodiDataSet]) {
        self.codiDataList = codiDataList
    }
}
