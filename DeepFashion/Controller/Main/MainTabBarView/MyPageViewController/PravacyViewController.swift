//
//  PravacyViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class PravacyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

extension PravacyViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle("개인정보/보안")
    }
}
