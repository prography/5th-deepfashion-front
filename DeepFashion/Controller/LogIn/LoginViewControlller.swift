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

    let navigationTitleStackView: UIStackView = {
        let navigationItemStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        navigationItemStackView.alignment = .center
        navigationItemStackView.axis = .vertical
        navigationItemStackView.spacing = 1
        return navigationItemStackView
    }()

    let titleImageView: UIImageView = {
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        titleImageView.image = UIImage(named: AssetIdentifier.Image.appIcon)
        titleImageView.contentMode = .scaleAspectFit
        return titleImageView
    }()

    let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        titleLabel.font = UIFont.titleFont(displaySize: 10)
        return titleLabel
    }()

    // MARK: Properties

    private var isAPIDataRequested = false {
        willSet {
            DispatchQueue.main.async {
                self.loginButton.isEnabled = !newValue
                self.signUpButton.isEnabled = !newValue
                self.indicatorView.checkIndicatorView(newValue)
            }
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
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        RequestAPI.shared.delegate = self
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
            let passwordText = self.passwordTextField.text,
            let tabBarController = self.tabBarController else { return }

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
                    ToastView.shared.presentShortMessage(tabBarController.view, message: "로그인에 실패했습니다.")
                    self.loginButton.isEnabled = true
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
        configureTextField()
        configureLoginButton()
    }
}
