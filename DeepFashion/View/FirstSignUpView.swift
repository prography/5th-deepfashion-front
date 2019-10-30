//
//  SignUpViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstSignUpView: UIViewController {
    
    /// MARK: - Outlets
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var nextPageButton: UIButton!
    
    /// MARK: - Property
    private var disposeBag = DisposeBag()
    private var signUpViewModel = SignUpViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        nextPageButton.isEnabled = false
//        bindUI()
    }

    private func bindUI() {
//        signUpViewModel.idInputText
//        .asObservable()
//        .bind(to: idTextField.rx.text.orEmpty)
//        .disposed(by: disposeBag)
    }
    
    deinit {
//        self.disposeBag = DisposeBag()
    }
    
}
