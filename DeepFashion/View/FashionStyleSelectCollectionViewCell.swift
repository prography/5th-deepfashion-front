//
//  FashionStyleSelectCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/29.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class FashionStyleSelectCollectionViewCell: UICollectionViewCell {
    @IBOutlet var styleTitleLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override var isSelected: Bool {
        willSet {
            if newValue {
                styleTitleLabel.backgroundColor = .black
                styleTitleLabel.textColor = .white
            } else {
                styleTitleLabel.backgroundColor = .white
                styleTitleLabel.textColor = .black
            }
            layoutIfNeeded()
        }
    }

    func configureCell(_ title: String, itemIndex _: Int) {
        styleTitleLabel.text = title
        backgroundColor = .white
    }

    func toggleCell(styles: inout [(String, Int)], itemIndex: Int) -> Bool {
        if styles[itemIndex].1 == 0 {
            styles[itemIndex].1 = 1
            isSelected = true
            return true
        } else {
            styles[itemIndex].1 = 0
            contentView.backgroundColor = .white
            styleTitleLabel.textColor = .black
            isSelected = false
            return false
        }
    }
}
