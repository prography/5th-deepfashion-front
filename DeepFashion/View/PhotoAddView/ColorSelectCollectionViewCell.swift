//
//  FashionColorSelectCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/21.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ColorSelectCollectionViewCell: UICollectionViewCell {
    private let colorImageView: UIImageView = {
        let colorImageView = UIImageView()
        colorImageView.image = UIImage(named: AssetIdentifier.Image.longJacket)
        colorImageView.contentMode = .scaleAspectFill
        return colorImageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(colorImageView)
    }

    private func makeConstraints() {
        colorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            colorImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            colorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            colorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ])
    }
}
