//
//  RequestAPIDelegate.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

protocol RequestAPIDelegate: class {
    func requestAPIDidBegin()
    func requestAPIDidFinished()
    func requestAPIDidError()
}
