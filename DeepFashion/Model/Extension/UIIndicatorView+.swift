//
//  UIIndicatorView+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/16.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func checkIndicatorView(_ isRunning: Bool) {
        if isRunning {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
