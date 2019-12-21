//
//  UIIdentifier.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UIIdentifier {
    static let mainView = "mainView"
    static let mainNavigationController = "MainNavigationController"

    static let mainStoryboard = "Main"
    struct ViewController {
        static let addFashion = "AddFashionViewController"
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
            static let styleColor = "styleColorSelectCollectionViewCell"
        }

        struct TableView {
            static let closetList = "closetListTableViewCell"
            static let myPage = "myPageTableViewCell"
            static let addFashion = "addFashionTableViewCell"
        }
    }

    struct StyleButton {
        static let startTagIndex = 101
        static let endWomenTagIndex = 110
        static let endManTagIndex = 106
        static let endMaxTagIndex = 110
    }
}
