//
//  UIIdentifier.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UIIdentifier {
    struct Color {
        static let mixedColorHexaCode: UInt64 = 0x181818
        static let colorHexaCode: [UInt64] = [
            UIIdentifier.Color.mixedColorHexaCode, 0xFFFFFA, 0xF7F1E0, 0xFFD700, 0xFFDED0, 0xD0EBFF, 0x3BB143,
            0xE0AFE8, 0xA9A9A9, 0xDAA652, 0xE88D00, 0xF783AD, 0x00B0FF, 0x047949, 0xC7EA46,
            0x863C9C, 0x424242, 0xB46A22, 0xFF5700, 0xEE2370, 0x1C7ED6, 0x708238, 0xC2DAD9,
            0x7A4ADA, 0x000000, 0x704301, 0xEE220C, 0x7B1624, 0x1B4872, 0x444930, 0x056F94,
        ]

        static let colorHexaCodeIndex: [UInt64: Int] = [
            0xFFFFFA: 1, 0xA9A9A9: 2, 0x424242: 3, 0x000000: 4, 0xF7F1E0: 5, 0xDAA652: 6, 0xB46A22: 7, 0x704301: 8,
            0xE88D00: 9, 0xFF5700: 10, 0xEE220C: 11, 0xFFDED0: 12, 0xF783AD: 13, 0xEE2370: 14, 0x7B1624: 15, 0xC2DAD9: 16,
            0xE0AFE8: 17, 0x863C9C: 18, 0x7A4ADA: 19, 0xD0EBFF: 20, 0x00B0FF: 21, 0x1C7ED6: 22, 0x1B4872: 23, 0x047949: 24,
            0x708238: 25, 0x444930: 26, 0x056F94: 27, 0xC7EA46: 28, 0x3BB143: 29, 0x181818: 30, 0xFFD700: 31,
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
    }

    struct Cell {
        struct CollectionView {
            static let closetList = "closetListCollectionViewCell"
            static let recommend = "recommendCollectionViewCell"
            static let codiList = "codiListCollectionViewCell"
            static let styleTitle = "styleTitleCollectionViewCell"
            static let colorSelect = "ColorSelectCollectionViewCell"
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
    }

    struct StyleButton {
        static let startTagIndex = 101
        static let endWomenTagIndex = 110
        static let endManTagIndex = 106
        static let endMaxTagIndex = 110
    }
}
