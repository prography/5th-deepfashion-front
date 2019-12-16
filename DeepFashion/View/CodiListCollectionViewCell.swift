//
//  CodiListCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var codiImageViewList: [UIImageView]!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.text = "# CodiList Title"
        titleLabel.font = UIFont().withSize(10)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        for i in codiImageViewList.indices {
            codiImageViewList[i].backgroundColor = .lightGray
            codiImageViewList[i].image = UIImage(named: "longJacket.jpg")
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureCell(itemIndex: Int) {
        guard let originText = titleLabel.text else { return }
        titleLabel.text = "\(originText), # \(itemIndex)번째 코디리스트"
    }
}
