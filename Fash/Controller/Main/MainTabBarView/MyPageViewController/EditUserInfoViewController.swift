//
//  EditUserViewController.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/02/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController {
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var editUserDataButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    private var gender: String = "M"
    private var userId: String = ""
    private var isAPIDateRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDateRequested)
            }
        }
    }

    private var isFillInData = false {
        didSet {
            self.editUserDataButton.configureButtonByStatus(isFillInData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userData = CommonUserData.shared.userData else { return }
        gender = userData.gender
        userId = userData.username
        idTextField.text = userId
        idTextField.delegate = self
        idTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        genderSegmentedControl.selectedSegmentIndex = gender == "M" ? 0 : 1
        editUserDataButton.configureBasicButton(title: "유저정보 변경", fontSize: 17)
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        RequestAPI.shared.delegate = self
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = nowText
        isFillInData = idTextField.checkValidId()
    }

    @IBAction func editUserButtonPressed(_: UIButton) {
        guard let tabBarController = self.tabBarController as? MainTabBarController,
            let nowUserNameText = idTextField.text else { return }
        view.endEditing(true)
        var styleIdList = [Int]()
        CommonUserData.shared.userData?.styles?.forEach {
            styleIdList.append($0.id)
        }

        let userDataToPut = UserAPIPutData(userName: nowUserNameText, gender: gender, styles: styleIdList, password: CommonUserData.shared.password)
        debugPrint("userDataToPut: \(userDataToPut)")

        presentBasicTwoButtonAlertController(title: "유저정보변경", message: "해당 정보로 유저정보를 변경하시겠습니까?") { isApproved in
            if isApproved {
                debugPrint("gender: \(self.gender), userId: \(nowUserNameText)")
                // request put data
                RequestAPI.shared.putAPIData(userDataToPut, APIMode: .putUserData) { error in
                    if error == nil {
                        let changedUserData = UserAPIData(username: userDataToPut.userName, gender: userDataToPut.gender, styles: CommonUserData.shared.userData?.styles)
                        CommonUserData.shared.setUserData(changedUserData)
                        tabBarController.presentToastMessage("유저정보 변경에 성공했습니다.")
                    } else {
                        tabBarController.presentToastMessage("유저정보 변경에 실패했습니다.")
                    }
                }
            }
        }
    }

    @IBAction func genderSegmentedControlValueChanged(_ sedner: UISegmentedControl) {
        if sedner.selectedSegmentIndex == 0 {
            gender = "M"
        } else {
            gender = "W"
        }
    }
}

extension EditUserInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditUserInfoViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        isAPIDateRequested = true
    }

    func requestAPIDidFinished() {
        isAPIDateRequested = false
    }

    func requestAPIDidError() {
        isAPIDateRequested = false
    }
}
