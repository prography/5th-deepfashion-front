//
//  UserFashionData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/29.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

struct UserClothingData {
    var image: UIImage
    var name: String
    // fashionType등의 데이터를 enum으로 바꿀 필요가 있을 것 같다.
    var fashionType: Int
    var fashionWeahter: [Int]
    var fashionStyle: [(String, Int)]
}
