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

class SecondSignUpView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpFinishedButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentifier.unwindToMain, sender: nil)
    }
}
