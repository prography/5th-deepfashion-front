//
//  CodiRecommendCollectionViewFlowLayout.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - CodiRecommendCollectionViewFlowLayout

class CodiRecommendCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var numberOfItemsPerRow = 2

    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        let interItemSpacing: CGFloat = 20
        var newItemSize = itemSize
        let itemsPerRow = numberOfItemsPerRow
        let totalSpacing = interItemSpacing * CGFloat(itemsPerRow - 1)
        let newWidth = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / CGFloat(itemsPerRow)
        newItemSize.width = max(newItemSize.width, newWidth)
        newItemSize.height = newItemSize.width
        itemSize = newItemSize
    }
}
