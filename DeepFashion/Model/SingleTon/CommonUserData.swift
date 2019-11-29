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
    private(set) var userToken: String = ""
    private(set) var password: String = ""
    private(set) var gender: Int = 0
    private(set) var selectedStyle = ["Casual": 0, "Formal": 0, "Street": 0, "Vintage": 0, "Hiphop": 0, "Sporty": 0, "Lovely": 0, "Luxury": 0, "Sexy": 0, "Modern": 0, "Chic": 0, "Purity": 0, "Dandy": 0]

    private(set) var userImage = [UIImage]()
    private init() {}

    func setUserData(id: String, password: String, gender: Int) {
        self.id = id
        self.password = password
        self.gender = gender
        userData = UserData(userName: id, styles: [], password: password, gender: gender)
        userImage = [UIImage]()
    }

    func addUserImage(_ image: UIImage) {
        userImage.append(image)
    }

    func setUserToken(_ token: String) {
        userToken = token
    }

    func toggleStyleData(styleName: String) -> Int {
        if selectedStyle[styleName] == 0 {
            selectedStyle[styleName] = 1
        } else {
            selectedStyle[styleName] = 0
        }
        userData?.configureStyle(styles: selectedStyle)
        return selectedStyle[styleName] ?? 0
    }

    func resetStyleData() {
        selectedStyle = ["Casual": 0, "Formal": 0, "Street": 0, "Vintage": 0, "Hiphop": 0, "Sporty": 0, "Lovely": 0, "Luxury": 0, "Sexy": 0, "Modern": 0, "Chic": 0, "Purity": 0, "Dandy": 0]
        userData?.configureStyle(styles: selectedStyle)
    }
}
