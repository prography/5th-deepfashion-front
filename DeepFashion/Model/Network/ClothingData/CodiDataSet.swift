//
//  CodiSetData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/19.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct CodiDataSet {
    private var codiSet = [CodiData]()

    mutating func configureData(dataSet codiListData: [CodiListData]) {
        codiSet = codiListData
    }
}
