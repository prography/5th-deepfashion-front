//
//  CodiSetData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/19.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Foundation

struct CodiDataSet {
    var timeStamp: Double
    private(set) var dataSet = [CodiData]()

    mutating func configureData(dataSet codiDataList: [CodiData]) {
        dataSet = codiDataList
    }
}
