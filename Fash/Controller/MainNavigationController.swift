//
//  MainNavigationController.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/14.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationBar.backgroundColor = UIColor(white: 1, alpha: 0.3)
//        navigationBar.alpha = 0.3
        view.backgroundColor = .clear
        navigationBar.isTranslucent = true
    }
}
