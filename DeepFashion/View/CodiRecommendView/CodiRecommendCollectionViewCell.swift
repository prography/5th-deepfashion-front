//
//  ClothingRecommendCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiRecommendCollectionViewCell: UICollectionViewCell {
    // MARK: UIs

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    private var selectEffectView: UIView = {
        let selectEffectView = UIView()
        selectEffectView.backgroundColor = .white
        selectEffectView.layer.borderColor = UIColor.black.cgColor
        selectEffectView.layer.borderWidth = 1
        selectEffectView.alpha = 0.7
        selectEffectView.isHidden = true
        return selectEffectView
    }()

    override var isSelected: Bool {
        didSet {
            self.selectEffectView.isHidden = !isSelected
        }
    }

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
    }

    // MARK: Methods

    func configureCell(title: String) {
        titleLabel.text = " \(title)"
    }
}
