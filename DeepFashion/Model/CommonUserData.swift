//
//  UserData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

final class CommonUserData {
    static let shared = CommonUserData()

    private(set) var userData: UserData?
    private(set) var id: String = ""
    private(set) var password: String = ""
    private(set) var gender: Int = 0
    private(set) var style = [Int](repeating: 0, count: 12)

    private init() {}

    func setUserData(id: String, password: String, gender: Int) {
        self.id = id
        self.password = password
        self.gender = gender
        userData = UserData(userName: id, styles: self.style, password: password, gender: gender)
    }

    func toggleStyleData(tagIndex: Int) -> Int {
        if style[tagIndex] == 0 {
            style[tagIndex] = 1
        } else {
            style[tagIndex] = 0
        }
        userData?.configureStyle(styles: style)
        return style[tagIndex]
    }
    
    
}
