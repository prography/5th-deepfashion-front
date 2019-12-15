//
//  CodiListCollectionViewFlowLayout.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/16.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - CodiListCollectionView's FlowLayout

class CodiListCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var numberOfItemsPerRow = 2

    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 50, right: 20)

        let interItemSpacing: CGFloat = 20
        var newItemSize = itemSize
        let itemsPerRow = numberOfItemsPerRow
        let totalSpacing = interItemSpacing * CGFloat(itemsPerRow - 1)
        let newWidth = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / CGFloat(itemsPerRow)
        newItemSize.width = max(newItemSize.width, newWidth)
        newItemSize.height = newItemSize.width * 1.1
        itemSize = newItemSize
    }
}
