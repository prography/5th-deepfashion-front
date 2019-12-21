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
        colorImageView.backgroundColor = .darkGray
        colorImageView.image = UIImage(named: AssetIdentifier.Image.longJacket)
        colorImageView.contentMode = .scaleAspectFill
        return colorImageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        makeConstraints()
    }

    func configureCell(color: UIColor) {
        backgroundColor = color
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
    }

    private func addSubviews() {}

    private func makeConstraints() {
//        colorImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            colorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
//            colorImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
//            colorImageView.heightAnchor.constraint(equalToConstant: 20),
//            colorImageView.widthAnchor.constraint(equalToConstant: 20),
//        ])
    }
}
