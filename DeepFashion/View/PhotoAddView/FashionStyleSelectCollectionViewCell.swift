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

    func configureCell(style: (String, Int)) {
        styleTitleLabel.text = style.0
        if style.1 == 0 {
            backgroundColor = .white
            styleTitleLabel.textColor = .black
        } else {
            backgroundColor = .black
            styleTitleLabel.textColor = .white
        }
    }

    func toggleCell(styles: inout [(String, Int)], itemIndex: Int) -> Bool {
        if styles[itemIndex].1 == 0 {
            styles[itemIndex].1 = 1
            backgroundColor = .black
            styleTitleLabel.textColor = .white
            return true
        } else {
            styles[itemIndex].1 = 0
            backgroundColor = .white
            styleTitleLabel.textColor = .black
            return false
        }
    }
}
