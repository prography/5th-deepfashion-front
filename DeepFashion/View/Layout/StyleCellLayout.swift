//
//  HomeLayout.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/29.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - EditStyleCollectionView's FlowLayout

class EditStyleCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var numberOfItemsPerRow: Int {
        get {
            var value = 0
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                value = 3
            } else {
                value = 5
            }
            return value
        }
        set {
            self.invalidateLayout()
        }
    }

    override func prepare() {
        super.prepare()
        guard collectionView != nil else { return }

        var newItemSize = itemSize
        let itemsPerRow = max(numberOfItemsPerRow, 1)
        let totalSpacing = minimumInteritemSpacing * CGFloat(itemsPerRow - 1)
        let newWidth = (collectionView!.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / CGFloat(itemsPerRow)
        newItemSize.width = max(newItemSize.width, newWidth)
        if itemSize.height > 0 {
            let aspectRatio: CGFloat = itemSize.width / itemSize.height
            newItemSize.height = newItemSize.width / aspectRatio * 0.6
        }
        itemSize = newItemSize
    }
}
