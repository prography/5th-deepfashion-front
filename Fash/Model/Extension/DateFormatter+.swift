//
//  DateFormatter+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

extension DateFormatter {
    func basicFormatString(timeStamp: Double) -> String {
        dateFormat = "yyyy년 MM월 dd일"
        locale = Locale(identifier: "ko_KR")
        return string(from: Date(timeIntervalSince1970: timeStamp))
    }
}
