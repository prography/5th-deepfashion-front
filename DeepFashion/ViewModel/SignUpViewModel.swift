//
//  SignUpViewModel.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 30/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    /// MARK: - Properties
    // id, password가 유효한지를 체크하는 behaviorSubject
    let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let passwordValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let passwordConfirmValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let passwordInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let passwordConfirmInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    /// MARK: - Properties
    var disposeBag = DisposeBag()
    
    func combine() {
        
    }
    
}