
//
//  TabBarController+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UITabBarController {
    func removeBackButton() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
}
