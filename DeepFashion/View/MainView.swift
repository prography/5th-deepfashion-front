//
//  ViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 27/10/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MainView: UIViewController {
    
    /// MARK: - IBOutlet
    
    /// MARK: - Properties
    
    /// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// MARK: - IBAction
    /// MARK: Transition
    @IBAction func SignUpButtonPressed(_: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.goToSignUp, sender: self)
    }
    
    /// MARK: Unwind
    @IBAction func prepareForUnwind(segue _: UIStoryboardSegue) {
        print("Unwind to MainView!")
    }
}

