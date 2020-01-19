//
//  LogoAnimationViewController.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/19.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class LogoAnimationViewController: UIViewController {
    private let logoAnimationView = LogoAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraint()
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            self.performSegue(withIdentifier: UIIdentifier.Segue.goToLogin, sender: nil)
        }
    }

    private func addSubviews() {
        view.addSubview(logoAnimationView)
    }

    private func makeConstraint() {
        logoAnimationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoAnimationView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            logoAnimationView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            logoAnimationView.topAnchor.constraint(equalTo: self.view.topAnchor),
            logoAnimationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}
