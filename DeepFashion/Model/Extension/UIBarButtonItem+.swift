//
//  UIBarButtonItem+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/19.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}
