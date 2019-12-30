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
        let navigationItemStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        navigationItemStackView.alignment = .center
        navigationItemStackView.axis = .vertical
        navigationItemStackView.spacing = 1
        navigationItemStackView.backgroundColor = .white
        navigationItemStackView.distribution = .fillProportionally
        return navigationItemStackView
    }()

    let titleImageView: UIImageView = {
        let titleImageView = UIImageView()
        titleImageView.image = UIImage(named: AssetIdentifier.Image.appLogo)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.alpha = 0.6
        return titleImageView
    }()

    // MARK: Properties

    private var isAPIDataRequested = false {
        willSet {
            DispatchQueue.main.async {
                if self.isFillInData {
                    self.loginButton.isEnabled = !newValue
                }
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
        loginButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }

    private func configureTextField() {
        idTextField.configureBasicTextField()
        idTextField.layer.cornerRadius = 5
        passwordTextField.configureBasicTextField()
        passwordTextField.layer.cornerRadius = 5
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

    private func makeNavigationTitle() {
        navigationTitleStackView.addArrangedSubview(titleImageView)
        navigationItem.titleView = navigationTitleStackView
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
        performSegue(withIdentifier: UIIdentifier.Segue.goToFirstSignUp, sender: nil)
    }

    @IBAction func loginButtonPressed(_: UIButton) {
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text,
            let navigationController = self.navigationController else { return }

        view.endEditing(true)

        let userData = LoginAPIPostData(userName: idText, password: passwordText)

        RequestAPI.shared.postAPIData(userData: userData, APIMode: APIPostMode.loginDataPost) { errorType in
            // 테스트용 조건 설정 중)
            if errorType == nil {
                DispatchQueue.main.async {
                    ToastView.shared.presentShortMessage(navigationController.view, message: "로그인에 성공했습니다.")
                    UserCommonData.shared.saveID(idText)
                    self.passwordTextField.text = ""
                    self.passwordTextField.configureBasicTextField()
                    self.performSegue(withIdentifier: UIIdentifier.Segue.goToMain, sender: nil)
                }
            } else {
                DispatchQueue.main.async {
                    ToastView.shared.presentShortMessage(navigationController.view, message: "로그인에 실패했습니다.")
                    self.loginButton.isEnabled = true
                }
            }
        }
    }

    // MARK: - Unwind

    @IBAction func prepareForUnwindToLogin(segue nowSegue: UIStoryboardSegue) {
        if let _ = nowSegue.source as? MyPageViewController,
            let navigationController = self.navigationController {
            ToastView.shared.presentShortMessage(navigationController.view, message: "로그아웃 되었습니다.")
        }

        if let _ = nowSegue.source as? LastSignUpViewController,
            let navigationController = self.navigationController {
            ToastView.shared.presentShortMessage(navigationController.view, message: "성공적으로 가입되었습니다.")
        }

        if let _ = nowSegue.source as? DeleteUserViewController,
            let navigationController = self.navigationController {
            ToastView.shared.presentShortMessage(navigationController.view, message: "회원 탈퇴가 완료되었습니다.")
        }
    }
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
        makeNavigationTitle()
        configureTextField()
        configureLoginButton()
        signUpButton.layer.cornerRadius = 10
        signUpButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }
}
