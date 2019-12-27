//
//  DeleteUserViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class DeleteUserViewController: UIViewController {
    @IBOutlet var titleLabelList: [UILabel]!
    @IBOutlet var passwordTextFieldList: [UITextField]!
    @IBOutlet var deleteUserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    @IBAction func deleteUserButtonPressed(_: UIButton) {}
}

extension DeleteUserViewController: UIViewControllerSetting {
    func configureViewController() {}
}
