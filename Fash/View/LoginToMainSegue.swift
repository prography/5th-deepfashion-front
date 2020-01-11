//
//  GoToMainViewSegue.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class LoginToMainSegue: UIStoryboardSegue {
    override func perform() {
        super.perform()

        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        source.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}
