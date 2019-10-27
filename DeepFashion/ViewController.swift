//
//  ViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentifier.goToSignUp, sender: self)
    }

}

