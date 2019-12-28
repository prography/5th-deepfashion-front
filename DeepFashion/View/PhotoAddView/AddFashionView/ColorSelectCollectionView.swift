//
//  ColorSelectCollectionView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/21.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ColorSelectCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = ColorList.lightPeach
        isScrollEnabled = true
        allowsSelection = true
    }

//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        return super.hitTest(point, with: event) as? ColorSelectCollectionView
//    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
