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
        let navigationItemStackView = UIStackView()
        navigationItemStackView.alignment = .fill
        navigationItemStackView.distribution = .fill
        navigationItemStackView.axis = .vertical
        navigationItemStackView.contentMode = .scaleAspectFit
        navigationItemStackView.spacing = 0
        navigationItemStackView.backgroundColor = .clear
        navigationItemStackView.clipsToBounds = true
        return navigationItemStackView
    }()

    let titleImageView: UIImageView = {
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        titleImageView.image = UIImage(named: AssetIdentifier.Image.fashTitle)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.contentMode = .scaleAspectFit
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

    private var isFillInData = false {
        didSet {
            loginButton.configureButtonByStatus(isFillInData)
        }
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

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        resignTextFieldFirstResponder()
        endIgnoringInteractionEvents()

        guard let userName = CommonUserData.shared.userData?.username else { return }
        idTextField.text = "\(userName)"
    }

    // MARK: Methods

    private func animateFadeOutTopView(_: TimeInterval = 0.5) {
        let topView = UIView()
        topView.bounds = view.bounds
        topView.frame = view.frame
        navigationController?.view.addSubview(topView)
        topView.backgroundColor = .white
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                           topView.alpha = 0.0
                       },
                       completion: { _ in
                           topView.removeFromSuperview()
        })
    }

    private func resignTextFieldFirstResponder() {
        idTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    private func configureLoginButton() {
        loginButton.configureDisabledButton()
    }

    private func configureSignUpButton() {
        signUpButton.layer.cornerRadius = 10
    }

    private func configureTextField() {
        idTextField.configureBasicTextField()
        idTextField.layer.cornerRadius = 10
        passwordTextField.configureBasicTextField()
        passwordTextField.layer.cornerRadius = 10
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
//        navigationTitleStackView.addArrangedSubview(titleImageView)
        navigationItem.titleView = titleImageView
    }

    private func requestUserData() {
        RequestAPI.shared.getAPIData(APIMode: .getUserData, type: UserAPIData.self) { networkError, userData in
            if networkError == nil {
                guard let userData = userData else { return }
                CommonUserData.shared.setUserData(userData)
                DispatchQueue.main.async {
                    guard let password = self.passwordTextField.text else { return }
                    CommonUserData.shared.savePassword(password)
                    self.passwordTextField.text = ""
                    self.passwordTextField.configureBasicTextField()
                    CommonUserData.shared.resetUserAPIData()
                    RequestAPI.shared.resetProperties()
                    CodiListGenerator.shared.resetCodiListGenerator()
                    self.performSegue(withIdentifier: UIIdentifier.Segue.goToMain, sender: nil)
                }
            } else {
                DispatchQueue.main.async {
                    guard let navigationController = self.navigationController,
                        let errorTitle = networkError?.errorTitle else { return }

                    ToastView.shared.presentShortMessage(navigationController.view, message: "로그인에 실패했습니다. \(errorTitle)")
                    self.loginButton.isEnabled = true
                }
            }
        }
    }

    private func requestLoginAPI(_ userData: LoginAPIPostData) {
        RequestAPI.shared.delegate = self
        view.endEditing(true)
        RequestAPI.shared.postAPIData(userData: userData, APIMode: APIPostMode.loginData) { errorType in
            // 테스트용 조건 설정 중)
            if errorType == nil {
                DispatchQueue.main.async {
                    self.requestUserData()
                }
            } else {
                DispatchQueue.main.async {
                    guard let navigationController = self.navigationController else { return }
                    ToastView.shared.presentShortMessage(navigationController.view, message: "로그인에 실패했습니다.")
                    self.loginButton.isEnabled = true
                }
            }
        }
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
            let passwordText = self.passwordTextField.text else { return }

        view.endEditing(true)

        let userData = LoginAPIPostData(userName: idText, password: passwordText)

        requestLoginAPI(userData)
    }

    // MARK: - Unwind

    @IBAction func prepareForUnwindToLogin(segue nowSegue: UIStoryboardSegue) {
        if let _ = nowSegue.source as? MyPageViewController,
            let navigationController = self.navigationController {
            ToastView.shared.presentShortMessage(navigationController.view, message: "로그아웃 되었습니다.")
        }

        if let _ = nowSegue.source as? LastSignUpViewController,
            let navigationController = self.navigationController {
            beginIgnoringInteractionEvents()
            ToastView.shared.presentShortMessage(navigationController.view, message: "성공적으로 가입되었습니다.\n자동으로 로그인을 진행합니다.")

            guard let signUpId = CommonUserData.shared.userData?.username else { return }
            let signUpUserData = LoginAPIPostData(userName: signUpId, password: CommonUserData.shared.password)
            requestLoginAPI(signUpUserData)
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
        configureSignUpButton()
        animateFadeOutTopView()
    }
}
