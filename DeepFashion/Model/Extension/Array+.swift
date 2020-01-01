//
//  Array+.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/23.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

extension Array where Element == ClothingAPIData {
    mutating func binarySearch(searchData: ClothingAPIData) -> Int? {
        var left = 0, right = count - 1
        while left <= right {
            let mid = (left + right) / 2
            if mid >= count { return nil }
            if self[mid].id == searchData.id {
                return mid
            }
            if self[mid].id < searchData.id {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return nil
    }
}
