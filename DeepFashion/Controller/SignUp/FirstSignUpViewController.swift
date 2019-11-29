//

// SignUpViewController.swift

// DeepFashion

//

// Created by MinKyeongTae on 27/10/2019.

// Copyright © 2019 MinKyeongTae. All rights reserved.

//

//
// SignUpViewController.swift
// DeepFashion
//
// Created by MinKyeongTae on 27/10/2019.
// Copyright © 2019 MinKyeongTae. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FirstSignUpViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet private var idTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var passwordConfirmTextField: UITextField!
    @IBOutlet private var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private var nextPageButton: UIButton!

    // MARK: - Properties

    private var _isFillInData = false
    private var isFillInData: Bool {
        set {
            _isFillInData = newValue
            self.nextPageButton.configureButtonByStatus(newValue)
        }

        get { return _isFillInData }
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureSignUpButton()
    }

    // MARK: - Method

    private func configureSignUpButton() {
        nextPageButton.configureDisabledButton()
    }

    private func configureTextField() {
        idTextField.configureBasicTextField()
        passwordTextField.configureBasicTextField()
        passwordConfirmTextField.configureBasicTextField()
    }

    private func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let alphabetSet = CharacterSet(charactersIn: MyCharacterSet.signUpAlphabet).inverted
        let numberSet = CharacterSet(charactersIn: MyCharacterSet.signUpNumber).inverted
        return character.rangeOfCharacter(from: alphabetSet) == nil
            || character.rangeOfCharacter(from: numberSet) == nil
    }

    private func checkFillInData() {
        guard let passwordText = self.passwordTextField.text else { return }
        let idStatus = idTextField.checkValidId()
        let passwordStatus = passwordTextField.checkValidPassword()
        let passwordConfirmStatus = passwordConfirmTextField.checkEqualToOriginPasword(originText: passwordText)
        isFillInData = idStatus && passwordStatus && passwordConfirmStatus
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let nextViewController = segue.destination as? SecondSignUpViewController else { return }
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text,
            let genderIndex = self.genderSegmentedControl?.selectedSegmentIndex else { return }

        nextViewController.isGenderMan = genderIndex == 0 ? true : false
        CommonUserData.shared.setUserData(id: idText, password: passwordText, gender: genderIndex)
    }

    // MARK: - IBAction

    @IBAction func textFieldEditingValueChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        while nowText.count > UserDataRule.Common.maxLength {
            nowText.removeLast()
        }
        sender.text = String(nowText)
        checkFillInData()
    }

    @IBAction func goToNextButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.goToSecondSignUp, sender: nil)
    }
}

extension FirstSignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return checkCharacter(textField: textField, character: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
