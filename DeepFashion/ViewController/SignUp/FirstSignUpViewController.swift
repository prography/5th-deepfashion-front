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
            if newValue {
                self.nextPageButton.isEnabled = true
            } else {
                self.nextPageButton.isEnabled = false
            }
        }

        get { return _isFillInData }
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }

    // MARK: - Method

    func configureTextField() {
        idTextField.configureBasicTextField()
        passwordTextField.configureBasicTextField()
        passwordConfirmTextField.configureBasicTextField()
    }

    func checkCharacter(textField _: UITextField, character: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: MyCharacterSet.signUp).inverted

        return character.rangeOfCharacter(from: characterSet) == nil
    }

    func checkFillInData() {
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text,
            let passwordConfirmText = self.passwordConfirmTextField.text else { return }

        isFillInData = (idText.trimmingCharacters(in: .whitespaces).count >= UserDataRule.Id.minLength &&
            passwordText.trimmingCharacters(in: .whitespaces).count >= UserDataRule.Password.minLength &&
            passwordConfirmText.trimmingCharacters(in: .whitespaces).count >= UserDataRule.Password.minLength &&
            passwordConfirmText == passwordText) ? true : false
        idTextField.checkValidId()
        passwordTextField.checkValidPassword()
        passwordConfirmTextField.checkEqualToOriginPasword(originText: passwordText)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let nextViewController = segue.destination as? SecondSignUpViewController else { return }
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text,
            let genderIndex = self.genderSegmentedControl?.selectedSegmentIndex else { return }

        nextViewController.isGenderMan = genderIndex == 0 ? true : false
        UserData.shared.setUserData(id: idText, password: passwordText, gender: genderIndex)
    }

    // MARK: - IBAction

    @IBAction func textFieldEditingValueChanged(_ sender: UITextField) {
        guard var nowText = sender.text else { return }
        if nowText.count > 10 {
            nowText.removeLast()
            DispatchQueue.main.async {
                sender.text = String(nowText)
            }
        }
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
}
