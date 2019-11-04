//
//  SecondSignUpViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 29/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SecondSignUpViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var signUpFinishButton: UIButton!

    // MARK: - Properties

    var isGenderMan = true

    private var _isFillInData = false
    private var isFillInData: Bool {
        set {
            _isFillInData = newValue
            signUpFinishButton.configureButtonByStatus(newValue)
        }

        get { return _isFillInData }
    }

    private var _styleSelectionCount = 0
    private var styleSelectionCount: Int {
        set {
            _styleSelectionCount = newValue
            isFillInData = newValue > 0 ? true : false
        }

        get { return _styleSelectionCount }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("now gender : \(isGenderMan)")
        configureStyleSelectButton()
    }

    // MARK: - Method

    private func configureStyleSelectButton() {
        let firstButtonTag = UIIdentifier.StyleButton.startTagIndex
        let lastButtonTag = UIIdentifier.StyleButton.endTagIndex
        for buttonIndex in firstButtonTag ... lastButtonTag {
            guard let styleButton = self.view.viewWithTag(buttonIndex) as? UIButton else { return }
            styleButton.configureDisabledButton()

            var nowButtonText = ""
            if isGenderMan {
                nowButtonText = FashionStyle.male[buttonIndex - firstButtonTag]
            } else {
                nowButtonText = FashionStyle.Female[buttonIndex - firstButtonTag]
            }

            if nowButtonText != "" {
                styleButton.setTitle(nowButtonText, for: .normal)
            } else {
                styleButton.alpha = 0
                styleButton.isEnabled = false
            }
        }
    }

    // MARK: - IBAction

    @IBAction func signUpFinishedButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.unwindToMain, sender: nil)
    }

    @IBAction func styleSelectButtonPressed(_ sender: UIButton) {
        let flag = UserData.shared.toggleStyleData(tagIndex: sender.tag - UIIdentifier.StyleButton.startTagIndex)

        if flag == 0 {
            sender.configureDisabledButton()
            styleSelectionCount -= 1
        } else {
            sender.configureSelectedButton()
            styleSelectionCount += 1
        }

        UserData.shared.style.forEach {
            print($0, terminator: " ")
        }
    }
}
