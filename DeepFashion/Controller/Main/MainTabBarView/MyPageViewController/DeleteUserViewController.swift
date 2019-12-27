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

    private var isFillInData = false {
        didSet {
            self.deleteUserButton.configureButtonByStatus(isFillInData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        guard let passwordText = self.passwordTextFieldList[0].text else { return }
        let passwordStatus = passwordTextFieldList[0].checkValidPassword()
        let passwordConfirmStatus = passwordTextFieldList[1].checkEqualToOriginPasword(originText: passwordText)
        isFillInData = passwordStatus && passwordConfirmStatus
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @objc func backButtonPressed(_: UIButton) {
        guard let navigationController = self.navigationController else { return }
        tabBarController?.removeBackButton()
        navigationController.popViewController(animated: true)
    }

    @IBAction func textFieldEditingValueChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = String(nowText)
        checkFillInData()
    }

    @IBAction func deleteUserButtonPressed(_: UIButton) {}
}

extension DeleteUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DeleteUserViewController: UIViewControllerSetting {
    func configureViewController() {
        configureDeleteUserButton()
        configureTitleLabeList()
        configurePasswordTextFieldList()
        configureBackButton()
        configurePasswordTextFieldList()
        configureTitleLabeList()
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
            passwordTextFieldList[i].delegate = self
        }
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
}
