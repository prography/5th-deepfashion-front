//
//  CodiCheckCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/06.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiCheckCollectionViewCell: UICollectionViewCell {
    // MARK: UIs

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.image = #imageLiteral(resourceName: "noClothing")
        return imageView
    }()

    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubviews()
        makeConstraints()
        layer.borderColor = ViewData.Color.borderColor
        layer.borderWidth = 1
        layer.cornerRadius = 3
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Methods

    func configureCell(image: UIImage) {
        imageView.image = image
    }

    private func addSubviews() {
        addSubview(imageView)
    }

    private func makeConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
}
