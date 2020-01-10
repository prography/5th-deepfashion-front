//
//  NSMutableData+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/04.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
        append(data)
    }
}
