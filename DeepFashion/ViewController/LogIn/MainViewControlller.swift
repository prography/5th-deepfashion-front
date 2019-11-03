//
//  ViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet var googleLoginButton: UIButton!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!

    // MARK: - Properties

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBAction

    // MARK: Transition

    @IBAction func SignUpButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.goToFirstSignUp, sender: self)
    }

    // MARK: Unwind

    @IBAction func prepareForUnwind(segue _: UIStoryboardSegue) {
        print("Unwind to MainView!")
    }
}
