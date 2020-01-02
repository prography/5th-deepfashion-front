//
//  UserData.swift
//  MovieInfoApp
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UserData {
    private(set) var userName = ""
    private(set) var style = [Int]()
    private(set) var password = ""
    private(set) var gender = ""
    init(userName: String, styles: Set<String>, password: String, gender genderIndex: Int) {
        self.userName = userName
        self.password = password
        gender = genderIndex == 0 ? "M" : "W"

        var newStyles = Set<Int>()
        for value in styles.enumerated() {
            guard let styleIndex = ClothingStyle.dictionary[value.element] else { continue }
            newStyles.insert(styleIndex)
        }

        style = newStyles.sorted()
    }

    mutating func configureStyle(styles: [String: Int]) {
        var newStyles = Set<Int>()
        let mappingStyles = styles.filter { $0.value == 1 }

        for (key, _) in mappingStyles {
            guard let styleIndex = ClothingStyle.dictionary[key] else { continue }
            newStyles.insert(styleIndex)
        }

        let orderedStyles = newStyles.sorted()
        style = orderedStyles
    }
}
