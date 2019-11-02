//
//  SecondSignUpViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 29/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SecondSignUpViewController: UIViewController {
    
    /// MARK: - Properties
    var disposeBag = DisposeBag()
    
    /// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// MARK: - IBAction
    @IBAction func signUpFinishedButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentifier.unwindToMain, sender: nil)
    }
    
    /// MARK: Deinit
    deinit {
        self.disposeBag = DisposeBag()
    }
}
