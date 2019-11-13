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

    // MARK: - Properties

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
        performSegue(withIdentifier: SegueIdentifier.goToFirstSignUp, sender: self)
    }

    @IBAction func loginButtonPressed(_: UIButton) {
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text else { return }
        let userData = UserLoginData(userName: idText, password: passwordText)
        RequestAPI.shared.postLoginAPIData(userData: userData) { userAPIData in
            print("succeed userAPIData is... \(String(describing: userAPIData))")
            self.performSegue(withIdentifier: SegueIdentifier.goToMain, sender: self)
        }
    }

    // MARK: Unwind

    @IBAction func prepareForUnwind(segue _: UIStoryboardSegue) {
        /// Data Check Test
        guard let userData = CommonUserData.shared.userData else { return }
        print("Current UsrData is... : \(userData)")
        RequestAPI.shared.postUserAPIData(userData: userData) { userAPIData in
            // API POST 요청 후 요청 성공 시 상관없이 userData 정보를 출력
            print("succeed userAPIData is... \(String(describing: userAPIData))")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        print("\(string)")
        return checkCharacter(textField: textField, character: string)
    }
}
