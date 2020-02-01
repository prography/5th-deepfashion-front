//
//  UIIdentifier.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UIIdentifier {
    struct Tag {
        static let typePickerView = 301
        static let stylePickerView = 302
    }

    struct Color {
        static let mixedColorHexaCode: UInt64 = 0x181818
        static let colorHexaCodeList: [UInt64] = [
            UIIdentifier.Color.mixedColorHexaCode, 0xFFFFFA, 0xF7F1E0, 0xFFD700, 0xFFDED0, 0xD0EBFF, 0x3BB143,
            0xE0AFE8, 0xA9A9A9, 0xDAA652, 0xE88D00, 0xF783AD, 0x00B0FF, 0x047949, 0xC7EA46,
            0x863C9C, 0x424242, 0xB46A22, 0xFF5700, 0xEE2370, 0x1C7ED6, 0x708238, 0xC2DAD9,
            0x7A4ADA, 0x000000, 0x704301, 0xEE220C, 0x7B1624, 0x1B4872, 0x444930, 0x056F94,
        ]

        static let colorHexaCodeIndex: [UInt64: Int] = [
            UIIdentifier.Color.mixedColorHexaCode: 0, 0xFFFFFA: 1, 0xF7F1E0: 2, 0xFFD700: 3, 0xFFDED0: 4, 0xD0EBFF: 5, 0x3BB143: 6,
            0xE0AFE8: 7, 0xA9A9A9: 8, 0xDAA652: 9, 0xE88D00: 10, 0xF783AD: 11, 0x00B0FF: 12, 0x047949: 13, 0xC7EA46: 14,
            0x863C9C: 15, 0x424242: 16, 0xB46A22: 17, 0xFF5700: 18, 0xEE2370: 19, 0x1C7ED6: 20, 0x708238: 21, 0xC2DAD9: 22,
            0x7A4ADA: 23, 0x000000: 24, 0x704301: 25, 0xEE220C: 26, 0x7B1624: 27, 0x1B4872: 28, 0x444930: 29, 0x056F94: 30,
        ]
    }

    static let mainView = "mainView"
    static let mainNavigationController = "MainNavigationController"
    static let mainTabBarController = "MainTabBarController"
    static let mainStoryboard = "Main"
    struct ViewController {
        static let editClothing = "AddFashionViewController"
        static let editStyle = "EditStyleViewController"
        static let privacy = "PrivacyViewController"
    }

    struct NibName {
        static let mainClothingInfoView = "MainClothingInfoView"
        static let colorSelectCollectionView = "ColorSelectCollectionView"
        static let codiAddView = "CodiAddView"
    }

    struct Cell {
        struct CollectionView {
            static let closetList = "closetListCollectionViewCell"
            static let recommend = "recommendCollectionViewCell"
            static let codiList = "codiListCollectionViewCell"
            static let styleTitle = "styleTitleCollectionViewCell"
            static let colorSelect = "ColorSelectCollectionViewCell"
            static let codiCheck = "CodiCheckCollectionViewCell"
        }

        struct TableView {
            static let closetList = "closetListTableViewCell"
            static let myPage = "myPageTableViewCell"
            static let editClothing = "addFashionTableViewCell"
            static let privacy = "privacyTableViewCell"
        }
    }

    struct Segue {
        static let goToMain = "goToMainView"
        static let goToFirstSignUp = "goToFirstSignUp"
        static let goToSecondSignUp = "goToSecondSignUp"
        static let unwindToLogin = "unwindToLogin"
        static let unwindToClothingAdd = "unwindToClothingAddView"
        static let goToPrivacy = "goToPrivacyView"
        static let goToDeleteUser = "goToDeleteUserView"
        static let goToEditUser = "goToEditUserView"
        static let goToLogin = "goToLoginView"
    }

    struct StyleButton {
        static let startTagIndex = 101
        static let endWomenTagIndex = 110
        static let endManTagIndex = 106
        static let endMaxTagIndex = 110
    }
}
