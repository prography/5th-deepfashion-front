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
                backgroundColor = ColorList.newBrown
                layer.borderColor = ColorList.lightPeach?.cgColor
                styleTitleLabel.textColor = .white
            } else {
                backgroundColor = ColorList.lightPeach
                layer.borderColor = ColorList.beige?.cgColor
                styleTitleLabel.textColor = .white
            }
        }
    }

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = ViewData.Color.borderColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        styleTitleLabel.font = UIFont.subFont(displaySize: 18)
        styleTitleLabel.textColor = ColorList.brownish
    }

    // MARK: Methods

    func configureCell(style: (String, Int), isSelected _: Bool) {
        backgroundColor = ColorList.lightPeach
        layer.borderColor = ColorList.beige?.cgColor
        styleTitleLabel.textColor = .white
        styleTitleLabel.text = style.0
    }
}
