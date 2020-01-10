//
//  RequestImageDelegate.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

protocol RequestImageDelegate: class {
    func imageRequestDidBegin()
    func imageRequestDidFinished(_ requestImage: UIImage, imageKey: String)
    func imageRequestDidError(_ errorDescription: String)
}
