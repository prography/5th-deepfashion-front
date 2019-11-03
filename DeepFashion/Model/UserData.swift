//
//  UserData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 03/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

final class UserData {
    static let shared = UserData()

    private(set) var id: String = ""
    private(set) var password: String = ""
    private(set) var gender: Int = 0
    private(set) var style = [Int](repeating: 0, count: 12)

    func setUserData(id: String, password: String, gender: Int) {
        self.id = id
        self.password = password
        self.gender = gender
    }
}
