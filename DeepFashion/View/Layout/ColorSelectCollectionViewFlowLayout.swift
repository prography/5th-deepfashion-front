//
//  StyleColorCollectionViewFlowLayout.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/21.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - CodiRecommendCollectionViewFlowLayout

class ColorSelectCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var numberOfItemsPerRow = 10

    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let itemsPerRow = numberOfItemsPerRow
        let interItemSpacing: CGFloat = 5
        var newItemSize = itemSize
        let totalSpacing = interItemSpacing * CGFloat(itemsPerRow - 1)
        let newWidth = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / CGFloat(itemsPerRow)
        newItemSize.width = newWidth
        newItemSize.height = newItemSize.width
        itemSize = newItemSize
    }
}
