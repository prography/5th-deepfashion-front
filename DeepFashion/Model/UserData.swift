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
    init(userName: String, styles: [Int], password: String, gender genderIndex: Int) {
        self.userName = userName
        self.password = password
        gender = genderIndex == 0 ? "M" : "W"

        var newStyles = [Int]()
        for i in styles.indices {
            if styles[i] == 1 {
                newStyles.append(i + 1)
            }
        }
        style = newStyles
    }

    mutating func configureStyle(styles: [Int]) {
        var newStyles = [Int]()
        for i in styles.indices {
            if styles[i] == 1 {
                newStyles.append(i + 1)
            }
        }
        style = newStyles
    }
}
