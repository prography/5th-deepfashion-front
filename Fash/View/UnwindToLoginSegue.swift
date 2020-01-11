//
//  UnwindToMainSegue.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class UnwindToLoginSegue: UIStoryboardSegue {
    override func perform() {
        super.perform()

        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromTop

        destination.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}
