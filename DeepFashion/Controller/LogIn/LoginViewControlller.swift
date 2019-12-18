//
//  ViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: Properties

    private var isAPIDataRequested = false {
        willSet {
            indicatorView.checkIndicatorView(newValue)
        }
    }

    private var _isFillInData = false
    private var isFillInData: Bool {
        set {
            _isFillInData = newValue
            loginButton.configureButtonByStatus(newValue)
        }

        get { return _isFillInData }
    }

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureLoginButton()
    }

    // MARK: Methods

    private func configureLoginButton() {
        loginButton.configureDisabledButton()
    }

    private func configureTextField() {
        idTextField.configureBasicTextField()
        passwordTextField.configureBasicTextField()
        idTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        let idStatus = idTextField.checkValidId()
        let passwordStatus = passwordTextField.checkValidPassword()
        isFillInData = idStatus && passwordStatus
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - IBActions

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = nowText
        checkFillInData()
    }

    // MARK: - Transition

    @IBAction func SignUpButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.goToFirstSignUp, sender: nil)
    }

    @IBAction func loginButtonPressed(_: UIButton) {
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text else { return }
        let userData = LoginAPIPostData(userName: idText, password: passwordText)
        RequestAPI.shared.postAPIData(userData: userData, APIMode: APIPostMode.loginDataPost) { errorType in
            // 테스트용 조건 설정 중)
            if errorType == nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifier.goToMain, sender: nil)
                }
            } else {
                // * ISSUE : 네트워킹 or 로그인 오입력에 따른 AlertController 띄울 예정
                DispatchQueue.main.async {
                    self.presentBasicOneButtonAlertController(title: errorType?.errorTitle ?? "로그인 에러", message: errorType?.errorMessage ?? "로그인 중 에러가 발생했습니다.") {
                        print("Dismiss the presentBasicOneButtonAlertController")
                    }
                }
            }
        }
    }

    // MARK: - Unwind

    @IBAction func prepareForUnwind(segue _: UIStoryboardSegue) {}
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: RequestAPIDelegate {
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
    }
}

extension LoginViewController: UIViewControllerSetting {
    func configureViewController() {
        RequestAPI.shared.delegate = self
    }
}
