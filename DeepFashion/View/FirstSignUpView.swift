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
    
    /// MARK: - IBOutlet
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var nextPageButton: UIButton!
    
    /// MARK: - Properties
    private var disposeBag = DisposeBag()
    private var signUpViewModel = SignUpViewModel()
    
    /// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    /// MARK: - Method
    private func bindUI() {
        // 입력값에 대한 체크 메서드 구현 필요
//        signUpViewModel.idInputText
//            .subscribe(onNext: { (S) in
//                print(S)
//            })
//            .disposed(by: disposeBag)
        
        // 입력값에 대한 실시간 감지 필요
        signUpViewModel.idInputText
            .bind(to: self.idTextField.rx.text)
            .disposed(by: disposeBag)
        signUpViewModel.passwordInputText
            .bind(to: self.passwordTextField.rx.text)
            .disposed(by: disposeBag)
        signUpViewModel.passwordConfirmInputText
            .bind(to: self.passwordConfirmTextField.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    /// MARK: - Deinit
    deinit {
        self.disposeBag = DisposeBag()
    }
    
}
