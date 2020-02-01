//
//  EditPasswordViewController.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/02/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class EditPasswordViewController: UIViewController {
    @IBOutlet var nowPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextFieldList: [UITextField]!
    @IBOutlet var savePasswordButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    private var isAPIDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested)
            }
        }
    }

    private var isFillInData = false {
        didSet {
            self.savePasswordButton.configureButtonByStatus(isFillInData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    private func configureTextField() {
        nowPasswordTextField.configureBasicTextField()
        nowPasswordTextField.layer.cornerRadius = 10
        nowPasswordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

        newPasswordTextFieldList.forEach {
            $0.configureBasicTextField()
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        let nowPasswordStatus = nowPasswordTextField.checkValidPassword()
        let newPasswordStatus = newPasswordTextFieldList[0].checkValidPassword() && newPasswordTextFieldList[1].checkValidPassword()
        isFillInData = nowPasswordStatus && newPasswordStatus
    }

    private func validateInputData() -> Bool {
        guard let nowPassword = self.nowPasswordTextField.text,
            let newPassword = self.newPasswordTextFieldList[0].text,
            let newPasswordConfirm = self.newPasswordTextFieldList[1].text else { return false }
        return nowPassword == CommonUserData.shared.password
            && newPassword == newPasswordConfirm
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = nowText
        checkFillInData()
    }

    @IBAction func savePasswordButtonPressed(_: UIButton) {
        view.endEditing(true)
        guard let tabBarController = self.tabBarController as? MainTabBarController,
            let changedPassword = newPasswordTextFieldList[0].text,
            let username = CommonUserData.shared.userData?.username,
            let gender = CommonUserData.shared.userData?.gender else { return }

        var styleIdList = [Int]()
        CommonUserData.shared.userData?.styles?.forEach {
            styleIdList.append($0.id)
        }

        let userDataToPut = UserAPIPutData(userName: username, gender: gender, styles: styleIdList, password: changedPassword)

        if validateInputData() {
            presentBasicTwoButtonAlertController(title: "비밀번호 변경", message: "정말 비밀번호를 변경하시겠습니까?") { isApproved in
                if isApproved {
                    print("비밀번호 변경!")
                    // request put data
                    RequestAPI.shared.putAPIData(userDataToPut, APIMode: .putUserData) { error in
                        if error == nil {
                            CommonUserData.shared.savePassword(changedPassword)
                            tabBarController.presentToastMessage("비밀번호 변경에 성공했습니다.")
                        } else {
                            tabBarController.presentToastMessage("비밀번호 변경에 실패했습니다.")
                        }
                    }
                }
            }
        } else {
            tabBarController.presentToastMessage("비밀번호를 정확하게 입력해주세요.")
        }
    }
}

extension EditPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditPasswordViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        isAPIDataRequested = true
    }

    func requestAPIDidFinished() {
        isAPIDataRequested = false
    }

    func requestAPIDidError() {
        isAPIDataRequested = false
    }
}

extension EditPasswordViewController: UIViewControllerSetting {
    func configureViewController() {
        RequestAPI.shared.delegate = self
        nowPasswordTextField.delegate = self
        newPasswordTextFieldList.forEach { $0.delegate = self }
        savePasswordButton.configureButtonByStatus(false)
        configureTextField()
    }
}
