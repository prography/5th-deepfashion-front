//
//  SecondSignUpViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 29/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class SecondSignUpViewController: UIViewController {
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var signUpFinishButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: Properties

    var isGenderMan = true
    private var isAPIDataRequested = false {
        willSet {
            indicatorView.checkIndicatorView(newValue)
        }
    }

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

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        RequestAPI.shared.delegate = self
        configureStyleSelectButton()
        configureSignUpFinishButton()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        CommonUserData.shared.resetStyleData()
        styleSelectionCount = 0
    }

    // MARK: Methods

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

    // MARK: - IBActions

    @IBAction func signUpFinishedButtonPressed(_: UIButton) {
        /// Data Check Test
        guard let userData = CommonUserData.shared.userData else { return }
        let userAPIData = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.style, password: userData.password)
        RequestAPI.shared.postAPIData(userData: userAPIData, APIMode: APIPostMode.userDataPost) { _, succeed in
            // API POST 요청 후 요청 성공 시 상관없이 userData 정보를 출력
            if succeed {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifier.unwindToMain, sender: nil)
                }
            } else {
                print("회원가입 에러 났음 ㅠㅠ...")
            }
        }
    }

    @IBAction func styleSelectButtonPressed(_ sender: UIButton) {
        guard let styleName = sender.titleLabel?.text else { return }
        print("now name : \(styleName)")
        let flag = CommonUserData.shared.toggleStyleData(styleName: styleName)

        if flag == 0 {
            configureStyleButtonDisabled(styleButton: sender)
            styleSelectionCount -= 1
        } else {
            configureStyleButtonSelected(styleButton: sender)
            styleSelectionCount += 1
        }
    }
}

extension SecondSignUpViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        // 인디케이터 동작
        isAPIDataRequested = true
    }

    func requestAPIDidFinished() {
        // 인디케이터 종료 및 세그 동작 실행
        isAPIDataRequested = false
    }

    func requestAPIDidError() {
        // 에러 발생 시 동작 실행
        isAPIDataRequested = false
        // 에러 발생 AlertController를 띄운다.
    }
}
