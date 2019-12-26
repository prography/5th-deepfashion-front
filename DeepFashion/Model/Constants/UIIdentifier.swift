//
//  UIIdentifier.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UIIdentifier {
    static let colorHexaCode: [UInt64] = [
        0xFFFFFA, 0xF7F1E0, 0xFFD700, 0xFFDED0, 0xD0EBFF, 0x3BB143, 0xFFFFFF,
        0xE0AFE8, 0xA9A9A9, 0xDAA652, 0xE88D00, 0xF783AD, 0x00B0FF, 0x047949, 0xC7EA46,
        0x863C9C, 0x424242, 0xB46A22, 0xFF5700, 0xEE2370, 0x1C7ED6, 0x708238, 0xC2DAD9,
        0x7A4ADA, 0x000000, 0x704301, 0xEE220C, 0x7B1624, 0x1B4872, 0x444930, 0x056F94,
    ]

    static let mainView = "mainView"
    static let mainNavigationController = "MainNavigationController"

    static let mainStoryboard = "Main"
    struct ViewController {
        static let editClothing = "AddFashionViewController"
        static let editStyle = "EditStyleViewController"
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
        }
    }

    struct StyleButton {
        static let startTagIndex = 101
        static let endWomenTagIndex = 110
        static let endManTagIndex = 106
        static let endMaxTagIndex = 110
    }
}
