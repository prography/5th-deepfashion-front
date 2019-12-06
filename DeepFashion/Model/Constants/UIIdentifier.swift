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
        static let editStyle = "StyleSelectViewController"
    }

    struct Cell {
        struct CollectionView {
            static let closetList = "closetListCollectionViewCell"
            static let styleTitle = "styleTitleCollectionViewCell"
        }

        struct TableView {
            static let closetList = "closetListTableViewCell"
        }
    }

    struct StyleButton {
        static let startTagIndex = 101
        static let endWomenTagIndex = 112
        static let endManTagIndex = 107
        static let endMaxTagIndex = 112
    }
}
