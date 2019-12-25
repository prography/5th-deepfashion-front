//
//  ClosetListCollectionViewFlowLayout.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/25.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - ClosetListCollectionViewFlowLayout

class ClosetListCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionViewHeight = self.collectionView?.layer.bounds.height else { return }
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)

        var newItemSize = itemSize
        newItemSize.height = CGFloat(collectionViewHeight) * 0.8
        newItemSize.width = newItemSize.height
        itemSize = newItemSize
    }
}
