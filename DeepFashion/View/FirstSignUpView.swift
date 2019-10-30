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
    private let disposeBag = DisposeBag()
    private var signUpViewModel = SignUpViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        nextPageButton.isEnabled = false
        bindUI()
    }
    
    private func bindUI() {
        
        // optional 바인딩 후 idInputTextSubject를 bind한다. 
//        self.idTextField.rx.text.orEmpty
//        .bind(to: idInputText)
//        .disposed(by: disposeBag)
        
//        nextPageButton.rx.tap
//        .asDriver()
//            .drive(onNext: { [weak self] _ in
//                if(nextPageButton.isEnabled) {
//                    self.
//                }
//        })
        
    }
    
}
