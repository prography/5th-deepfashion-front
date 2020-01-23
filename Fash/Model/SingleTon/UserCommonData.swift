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

    private(set) var userData: UserAPIData?
    private(set) var pk: Int = 0
    private(set) var userToken: String = ""
    private(set) var password: String = ""
    private(set) var gender: Int = 0 // 0 남자, 1 여자
    private(set) var isNeedToUpdateClothing = false
    private(set) var needToUpdatePartIndex = [Bool](repeating: false, count: 4)
    private(set) var isNeedToUpdateCodiList = false
    private(set) var selectedStyle = ["Casual": 0, "Formal": 0, "Street": 0, "Vintage": 0, "Hiphop": 0, "Sporty": 0, "Lovely": 0, "Luxury": 0, "Sexy": 0, "Modern": 0, "Chic": 0, "Purity": 0, "Dandy": 0]
    private(set) var nowClothingCode: Int = 0

    private(set) var clothingDataList = [ClothingAPIData]()
    private(set) var codiListCollection = [CodiListAPIData]()
    var thumbnailImageCache = NSCache<NSString, UIImage>()

    private init() {}

    func setUserData(_ userData: UserAPIData) {
        self.userData = userData
        debugPrint("now UserData : \(userData)")
    }

    func savePassword(_ password: String) {
        self.password = password
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
//        userData?.configureStyle(styles: selectedStyle)
        return selectedStyle[styleName] ?? 0
    }

    func setClothingCode(_ clothingCode: Int) {
        nowClothingCode = clothingCode
    }

    func resetImageCache() {
        thumbnailImageCache = NSCache<NSString, UIImage>()
    }

    func resetStyleData() {
        selectedStyle = ["Casual": 0, "Formal": 0, "Street": 0, "Vintage": 0, "Hiphop": 0, "Sporty": 0, "Lovely": 0, "Luxury": 0, "Sexy": 0, "Modern": 0, "Chic": 0, "Purity": 0, "Dandy": 0]
//        userData?.configureStyle(styles: selectedStyle)
    }

    func setNeedToUpdatePartIndex(_ index: Int, _ value: Bool) {
        needToUpdatePartIndex[index] = value
    }

    func resetClothingData() {
        clothingDataList = [ClothingAPIData]()
    }

    func resetCodiListData() {
        codiListCollection = [CodiListAPIData]()
    }

    func resetUserAPIData() {
        resetImageCache()
        resetClothingData()
        resetCodiListData()
    }

    func configureClothingData(_ clothingDataList: [ClothingAPIData]) {
        self.clothingDataList = clothingDataList
    }

    func configureCodiListCollection(_ codiListCollection: [CodiListAPIData]) {
        self.codiListCollection = codiListCollection
    }

    func setIsNeedToUpdateClothingTrue() {
        isNeedToUpdateClothing = true
    }

    func setIsNeedToUpdateClothingFalse() {
        isNeedToUpdateClothing = false
    }

    func setIsNeedToUpdateCodiListTrue() {
        isNeedToUpdateCodiList = true
    }

    func setIsNeedToUpdateCodiListFalse() {
        isNeedToUpdateCodiList = false
    }

//    func addCodiData(_ codiData: [CodiListAPIData]) {
//        let nowTimeStamp = Date().timeIntervalSince1970
//        var codiDataSet = CodiDataSet(timeStamp: nowTimeStamp)
//        codiDataSet.configureData(dataSet: codiData)
//        codiListCollection.append(codiDataSet)
//    }
//
//    func configureCodiDataList(_ codiDataList: [CodiDataSet]) {
//        self.codiDataList = codiDataList
//    }
}
