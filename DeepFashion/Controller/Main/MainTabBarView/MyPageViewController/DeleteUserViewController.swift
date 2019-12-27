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

    private func configureBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        backButton.setTitleColor(.white, for: .normal)
        backButton.tintColor = .white
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        tabBarController?.navigationItem.leftBarButtonItem = backBarButton
    }

    @objc func backButtonPressed(_: UIButton) {
        guard let navigationController = self.navigationController else { return }
        tabBarController?.removeBackButton()
        navigationController.popViewController(animated: true)
    }

    @IBAction func deleteUserButtonPressed(_: UIButton) {}
}

extension DeleteUserViewController: UIViewControllerSetting {
    func configureViewController() {
        configureDeleteUserButton()
        configureTitleLabeList()
        configurePasswordTextFieldList()
        configureBackButton()
    }

    func configureDeleteUserButton() {
        deleteUserButton.configureDisabledButton()
        deleteUserButton.titleLabel?.font = UIFont.mainFont(displaySize: 13)
        deleteUserButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    func configureTitleLabeList() {
        for i in titleLabelList.indices {
            if i == 0 {
                titleLabelList[i].font = UIFont.subFont(displaySize: 18)
                titleLabelList[i].textColor = .white
                titleLabelList[i].backgroundColor = ColorList.newBrown
            } else {
                titleLabelList[i].font = UIFont.mainFont(displaySize: 18)
                titleLabelList[i].textColor = ColorList.brownish
            }
            titleLabelList[i].adjustsFontSizeToFitWidth = true
        }
    }

    func configurePasswordTextFieldList() {
        for i in passwordTextFieldList.indices {
            passwordTextFieldList[i].configureBasicTextField()
        }
    }
}
