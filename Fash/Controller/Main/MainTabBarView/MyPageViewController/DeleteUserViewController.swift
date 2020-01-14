//
//  DeleteUserViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class DeleteUserViewController: UIViewController {
    @IBOutlet var titleLabelList: [UILabel]!
    @IBOutlet var passwordTextFieldList: [UITextField]!
    @IBOutlet var deleteUserButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var titleHeaderBackgroundView: UIView!

    private let titleHeaderView = MyPageTableHeaderView()

    private var isFillInData = false {
        didSet {
            DispatchQueue.main.async {
                self.deleteUserButton.isEnabled = self.isFillInData
                self.deleteUserButton.configureButtonByStatus(self.isFillInData)
            }
        }
    }

    private var isAPIDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                if self.isFillInData {
                    self.deleteUserButton.isEnabled = !self.isAPIDataRequested
                }
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: - Methods

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        guard let passwordText = self.passwordTextFieldList[0].text else { return }
        let passwordStatus = passwordTextFieldList[0].checkValidPassword()
        let passwordConfirmStatus = passwordTextFieldList[1].checkEqualToOriginPasword(originText: passwordText)
        isFillInData = passwordStatus && passwordConfirmStatus
    }

    private func deleteUserData() {
        guard let tabBarController = self.tabBarController else { return }

        RequestAPI.shared.deleteAPIData(APIMode: .deleteUser) { networkError in
            DispatchQueue.main.async { [weak self] in
                if networkError != nil {
                    guard let errorMessage = networkError?.errorMessage else { return }
                    ToastView.shared.presentShortMessage(tabBarController.view, message: errorMessage)
                } else {
                    self?.performSegue(withIdentifier: UIIdentifier.Segue.unwindToLogin, sender: nil)
                }
            }
        }
    }

    private func configureTitleHeaderView() {
        titleHeaderView.configureTitleLabel("회원 탈퇴")
        titleHeaderView.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        titleHeaderBackgroundView.addSubview(titleHeaderView)

        titleHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleHeaderView.leftAnchor.constraint(equalTo: titleHeaderBackgroundView.leftAnchor),
            titleHeaderView.rightAnchor.constraint(equalTo: titleHeaderBackgroundView.rightAnchor),
            titleHeaderView.topAnchor.constraint(equalTo: titleHeaderBackgroundView.topAnchor),
            titleHeaderView.bottomAnchor.constraint(equalTo: titleHeaderBackgroundView.bottomAnchor),
        ])
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func textFieldEditingValueChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = String(nowText)
        checkFillInData()
    }

    @objc func backButtonPressed(_: UIButton) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }

    @IBAction func deleteUserButtonPressed(_: UIButton) {
        // pk값과 비밀번호 값으로 delete요청을 날려 탈퇴가능한지를 확인한다.
        // 1) 탈퇴가 가능하면 탈퇴처리를 하고 탈퇴되었음을 띄우고 로그아웃 처리한다.
        // 2) 탈퇴가 실패하면 실패 문구를 띄운다.
        view.endEditing(true)

        guard let tabBarController = self.tabBarController,
            let password = self.passwordTextFieldList[0].text else { return }

        let userData = LoginAPIPostData(userName: UserCommonData.shared.id, password: password)

        RequestAPI.shared.postAPIData(userData: userData, APIMode: APIPostMode.loginData) { [weak self] errorType in
            if errorType != nil {
                DispatchQueue.main.async {
                    ToastView.shared.presentShortMessage(tabBarController.view, message: "비밀번호 혹은 네트워크상태를 확인해주세요.")
                }
            } else {
                self?.deleteUserData()
            }
        }
    }
}

extension DeleteUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DeleteUserViewController: UIViewControllerSetting {
    func configureViewController() {
        configureTitleHeaderView()
        configureDeleteUserButton()
        configureTitleLabeList()
        configurePasswordTextFieldList()
        configureTitleLabeList()
        RequestAPI.shared.delegate = self
    }

    private func configureDeleteUserButton() {
        deleteUserButton.configureDisabledButton()
        deleteUserButton.titleLabel?.font = UIFont.mainFont(displaySize: 13)
        deleteUserButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    private func configureTitleLabeList() {
        for i in titleLabelList.indices {
            if i == 0 {
                titleLabelList[i].font = UIFont.subFont(displaySize: 16)
                titleLabelList[i].textColor = .white
                titleLabelList[i].backgroundColor = ColorList.newBrown
            } else {
                titleLabelList[i].font = UIFont.mainFont(displaySize: 18)
                titleLabelList[i].textColor = ColorList.brownish
            }
            titleLabelList[i].adjustsFontSizeToFitWidth = true
        }
    }

    private func configurePasswordTextFieldList() {
        for i in passwordTextFieldList.indices {
            passwordTextFieldList[i].configureBasicTextField()
            passwordTextFieldList[i].delegate = self
        }
    }
}

extension DeleteUserViewController: RequestAPIDelegate {
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
