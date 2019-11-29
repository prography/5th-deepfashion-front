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

    func configureCell(_ title: String) {
        styleTitleLabel.text = title
    }
}
