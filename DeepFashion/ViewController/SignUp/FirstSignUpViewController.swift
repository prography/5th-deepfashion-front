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

import UIKit
import RxSwift
import RxCocoa

class FirstSignUpViewController: UIViewController {
    
    /// MARK: - IBOutlet
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var nextPageButton: UIButton!
    
    /// MARK: - Properties
    private var _isFillInData = false
    private var isFillInData: Bool {
        set {
            if newValue {
                self.nextPageButton.isEnabled = true
            }
            else {
                self.nextPageButton.isEnabled = false
            }
        }
        
        get { return _isFillInData }
    }
    
    /// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// MARK: - Method
    func checkCharacter(textField: UITextField, character: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: MyCharacterSet.signUp).inverted
        
        return character.rangeOfCharacter(from: characterSet) == nil
    }
    
    func checkFillInData() {
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text,
            let passwordConfirmText = self.passwordConfirmTextField.text else { return }
        
        self.isFillInData = (idText.trimmingCharacters(in: .whitespaces).count >= 6 &&
            passwordText.trimmingCharacters(in: .whitespaces).count >= 8 &&
            passwordConfirmText.trimmingCharacters(in: .whitespaces).count >= 8 &&
            passwordConfirmText == passwordText) ? true : false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController = segue.destination as? SecondSignUpViewController else { return }
        guard let idText = self.idTextField.text,
            let passwordText = self.passwordTextField.text,
            let genderIndex = self.genderSegmentedControl?.selectedSegmentIndex else { return }
        
        nextViewController.isGenderMan = genderIndex == 0 ? true : false
        UserData.shared.setUserData(id: idText, password: passwordText, gender: genderIndex, style: [])
    }
    
    /// MARK: - IBAction
    
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
    
    @IBAction func goToNextButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: SegueIdentifier.goToSecondSignUp, sender: nil)
        
    }
}

extension FirstSignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return checkCharacter(textField: textField, character: string)
    }
}
