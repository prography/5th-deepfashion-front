//
//  UserData.swift
//  MovieInfoApp
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct UserData {
    private var userName = ""
    private var styles = ""
    private var password = ""
    private var gender = ""
    init(userName: String, styles: String, password: String, gender: String) {
        self.userName = userName
        self.styles = styles
        self.password = password
        self.gender = gender
    }
}

