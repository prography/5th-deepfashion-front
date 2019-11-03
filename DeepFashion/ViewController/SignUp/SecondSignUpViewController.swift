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
    // MARK: - Properties

    var isGenderMan = true

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("now gender : \(isGenderMan)")
    }

    // MARK: - IBAction

    @IBAction func signUpFinishedButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.unwindToMain, sender: nil)
    }
}
