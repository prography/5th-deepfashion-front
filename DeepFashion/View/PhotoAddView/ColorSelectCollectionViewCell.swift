//
//  FashionColorSelectCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/21.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ColorSelectCollectionViewCell: UICollectionViewCell {
    private let selectImageView: UIImageView = {
        let selectImageView = UIImageView()
        selectImageView.image = UIImage(named: AssetIdentifier.Image.longJacket)
        selectImageView.contentMode = .scaleAspectFill
        return selectImageView
    }()

    override var isSelected: Bool {
        willSet {
            toggleCell(isSelected: newValue)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        makeConstraints()
    }

    func configureCell(color: UIColor) {
        backgroundColor = color
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }

    private func toggleCell(isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 5
        } else {
            layer.borderWidth = 1
        }
    }

    private func addSubviews() {
        addSubview(selectImageView)
    }

    private func makeConstraints() {
        selectImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            selectImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            selectImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            selectImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
}
