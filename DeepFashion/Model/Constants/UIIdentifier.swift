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
    }

    struct Cell {
        struct CollectionView {
            static let closetList = "closetListCell"
            static let styleTitle = "styleTitleCell"
        }
    }

    struct StyleButton {
        static let startTagIndex = 101
        static let endTagIndex = 112
    }
}
