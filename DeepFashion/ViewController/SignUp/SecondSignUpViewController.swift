//
//  SecondSignUpViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 29/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SecondSignUpViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var signUpFinishButton: UIButton!

    // MARK: - Properties

    var isGenderMan = true

    private var _isFillInData = false
    private var isFillInData: Bool {
        set {
            _isFillInData = newValue
            signUpFinishButton.configureButtonByStatus(newValue)
        }

        get { return _isFillInData }
    }

    private var _styleSelectionCount = 0
    private var styleSelectionCount: Int {
        set {
            _styleSelectionCount = newValue
            isFillInData = newValue > 0 ? true : false
        }

        get { return _styleSelectionCount }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStyleSelectButton()
        configureSignUpFinishButton()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        styleSelectionCount = 0
    }

    // MARK: - Method

    private func configureSignUpFinishButton() {
        signUpFinishButton.configureDisabledButton()
    }

    private func configureStyleButtonDisabled(styleButton: UIButton) {
        styleButton.configureDisabledButton()
        styleButton.backgroundColor = .white
    }

    private func configureStyleButtonSelected(styleButton: UIButton) {
        styleButton.configureSelectedButton()
    }

    private func configureStyleSelectButton() {
        let firstButtonTag = UIIdentifier.StyleButton.startTagIndex
        let lastButtonTag = UIIdentifier.StyleButton.endTagIndex
        for buttonIndex in firstButtonTag ... lastButtonTag {
            guard let styleButton = self.view.viewWithTag(buttonIndex) as? UIButton else { return }
            configureStyleButtonDisabled(styleButton: styleButton)

            var nowButtonText = ""
            if isGenderMan {
                nowButtonText = FashionStyle.male[buttonIndex - firstButtonTag]
            } else {
                nowButtonText = FashionStyle.Female[buttonIndex - firstButtonTag]
            }

            if nowButtonText != "" {
                styleButton.setTitle(nowButtonText, for: .normal)
            } else {
                styleButton.alpha = 0
                styleButton.isEnabled = false
            }
        }
    }

    // MARK: - IBAction

    @IBAction func signUpFinishedButtonPressed(_: UIButton) {
        /// Data Check Test
        guard let userData = CommonUserData.shared.userData else { return }
        let userAPIData = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.style, password: userData.password)
        RequestAPI.shared.postAPIData(userData: userAPIData, APIMode: APIMode.userDataPost) { userAPIData in
            // API POST 요청 후 요청 성공 시 상관없이 userData 정보를 출력
            print("succeed userAPIData is... \(String(describing: userAPIData))")
            self.performSegue(withIdentifier: SegueIdentifier.unwindToMain, sender: nil)
        }
    }

    @IBAction func styleSelectButtonPressed(_ sender: UIButton) {
        let flag = CommonUserData.shared.toggleStyleData(tagIndex: sender.tag - UIIdentifier.StyleButton.startTagIndex)

        if flag == 0 {
            configureStyleButtonDisabled(styleButton: sender)
            styleSelectionCount -= 1
        } else {
            configureStyleButtonSelected(styleButton: sender)
            styleSelectionCount += 1
        }

        CommonUserData.shared.style.forEach {
            print($0, terminator: " ")
        }
    }
}
