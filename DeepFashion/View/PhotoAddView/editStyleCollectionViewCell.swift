//
//  FashionStyleSelectCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/29.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class editStyleCollectionViewCell: UICollectionViewCell {
    // MARK: UIs

    @IBOutlet var styleTitleLabel: UILabel!

    // MARK: Properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .black
                styleTitleLabel.textColor = .white
            } else {
                backgroundColor = .white
                styleTitleLabel.textColor = .black
            }
        }
    }

    // MARK: Life Cycle

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Methods

    func configureCell(style: (String, Int), isSelected _: Bool) {
//        self.isSelected = isSelected
        styleTitleLabel.text = style.0
    }
}
