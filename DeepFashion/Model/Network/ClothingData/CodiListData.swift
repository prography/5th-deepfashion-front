//
//  CodiSetData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/19.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct CodiListData {
    private var codiSet = [CodiListData]()

    mutating func configureData(dataSet codiListData: [CodiListData]) {
        codiSet = codiListData
    }
}
