//
//  SecondSignUpViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 29/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class LastSignUpViewController: UIViewController {
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var signUpFinishButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: Properties

    var isGenderMan = true
    private var isAPIDataRequested = false {
        willSet {
            DispatchQueue.main.async {
                self.signUpFinishButton.isEnabled = !newValue
                self.indicatorView.checkIndicatorView(newValue)
            }
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
        configureStyleSelectButton()
        configureSignUpFinishButton()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        RequestAPI.shared.delegate = self
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        UserCommonData.shared.resetStyleData()
        styleSelectionCount = 0
    }

    // MARK: Methods

    private func configureSignUpFinishButton() {
        signUpFinishButton.configureBasicButton(title: "가입 완료", fontSize: 18)
        signUpFinishButton.configureDisabledButton()
    }

    private func configureStyleButtonDisabled(styleButton: UIButton) {
        styleButton.configureDisabledButton()
        styleButton.isEnabled = true
        styleButton.backgroundColor = .white
    }

    private func configureStyleButtonSelected(styleButton: UIButton) {
        styleButton.configureSelectedButton()
    }

    private func configureStyleSelectButton() {
        let firstButtonTag = UIIdentifier.StyleButton.startTagIndex
        let lastButtonTag = UIIdentifier.StyleButton.endMaxTagIndex
        for buttonIndex in firstButtonTag ... lastButtonTag {
            guard let styleButton = self.view.viewWithTag(buttonIndex) as? UIButton else { return }
            configureStyleButtonDisabled(styleButton: styleButton)

            styleButton.layer.borderColor = UIColor.black.cgColor
            styleButton.layer.borderWidth = 3
            styleButton.layer.cornerRadius = 10

            var nowButtonText = ""
            if isGenderMan {
                if buttonIndex <= UIIdentifier.StyleButton.endManTagIndex {
                    nowButtonText = FashionStyle.male[buttonIndex - firstButtonTag]
                }
            } else {
                nowButtonText = FashionStyle.female[buttonIndex - firstButtonTag]
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
        guard let userData = UserCommonData.shared.userData else { return }
        let userAPIData = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.style, password: userData.password)
        RequestAPI.shared.postAPIData(userData: userAPIData, APIMode: APIPostMode.userDataPost) { errorType in
            // API POST 요청 후 요청 성공 시 상관없이 userData 정보를 출력
            DispatchQueue.main.async {
                if errorType == nil {
                    self.performSegue(withIdentifier: SegueIdentifier.unwindToLogin, sender: nil)
                } else {
                    // * ISSUE : 네트워킹 or 회원가입 오입력에 따른 AlertController 띄울 예정
                    self.presentBasicOneButtonAlertController(title: "회원가입 오류", message: "회원가입에 실패했습니다.", completion: nil)
                }
            }
        }
    }

    @IBAction func styleSelectButtonPressed(_ sender: UIButton) {
        guard let styleName = sender.titleLabel?.text else { return }

        let flag = UserCommonData.shared.toggleStyleData(styleName: styleName)

        if flag == 0 {
            configureStyleButtonDisabled(styleButton: sender)
            styleSelectionCount -= 1
        } else {
            configureStyleButtonSelected(styleButton: sender)
            styleSelectionCount += 1
        }
    }
}

extension LastSignUpViewController: RequestAPIDelegate {
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