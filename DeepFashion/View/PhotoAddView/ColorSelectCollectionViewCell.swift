//
//  FashionColorSelectCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/21.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ColorSelectCollectionViewCell: UICollectionViewCell {
    // MARK: UIs

    private let selectImageView: UIImageView = {
        let selectImageView = UIImageView()
        selectImageView.image = UIImage(named: AssetIdentifier.Image.longJacket)
        selectImageView.contentMode = .scaleAspectFill
        return selectImageView
    }()

    // MARK: Properties

    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 5 : 1
        }
    }

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        makeConstraints()
    }

    // MARK: Methodss

    func configureCell(color: UIColor) {
        backgroundColor = color
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
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
