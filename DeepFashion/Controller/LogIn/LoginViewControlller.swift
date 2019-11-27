//
//  ViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var googleLoginButton: UIButton!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: - Properties

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

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        RequestAPI.shared.delegate = self
        configureTextField()
        configureLoginButton()
    }

    // MARK: - Method

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

    // MARK: - IBAction

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = nowText
        checkFillInData()
    }

    // MARK: Transition

    @IBAction func SignUpButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.goToFirstSignUp, sender: nil)
    }

    @IBAction func loginButtonPressed(_: UIButton) {
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text else { return }
        let userData = LoginAPIPostData(userName: idText, password: passwordText)
        RequestAPI.shared.postAPIData(userData: userData, APIMode: APIMode.loginDataPost) { _, succeed in
            // 테스트용 조건 설정 중)
            if succeed {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueIdentifier.goToMain, sender: nil)
                }
            } else {
                print("에러났음 ㅠㅠ")
            }
        }
    }

    // MARK: Unwind

    @IBAction func prepareForUnwind(segue _: UIStoryboardSegue) {}
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
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
