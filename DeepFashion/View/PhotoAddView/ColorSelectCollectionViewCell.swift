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

    var nowRGB: UInt64 = 0
    private let selectImageView: UIImageView = {
        let selectImageView = UIImageView()
        selectImageView.image = UIImage(named: AssetIdentifier.Image.check)
        selectImageView.contentMode = .scaleAspectFill
        selectImageView.alpha = 0.7
        return selectImageView
    }()

    private let mixedColorImageView: UIImageView = {
        let mixedColorImageView = UIImageView()
        mixedColorImageView.contentMode = .scaleAspectFill
        mixedColorImageView.image = UIImage(named: AssetIdentifier.Image.mixedColor)
        return mixedColorImageView
    }()

    // MARK: Properties

    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 3 : 1
            selectImageView.isHidden = !isSelected
        }
    }

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Methodss

    func configureCell(rgb: UInt64) {
        addSubviews()
        makeConstraints()
        configureCellColor(rgb: rgb)
        layer.borderColor = ViewData.Color.borderColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
        clipsToBounds = true
        selectImageView.isHidden = true
    }

    private func configureCellColor(rgb: UInt64) {
        nowRGB = rgb
        if nowRGB == 0x181818 {
            mixedColorImageView.isHidden = false
            mixedColorImageView.clipsToBounds = true
        } else {
            mixedColorImageView.isHidden = true
            let cellColor = UIColor(rgb: nowRGB, alpha: 1.0)
            backgroundColor = cellColor
        }
    }

    private func addSubviews() {
        contentView.addSubview(mixedColorImageView)
        addSubview(selectImageView)
    }

    private func makeConstraints() {
        mixedColorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mixedColorImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            mixedColorImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            mixedColorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            mixedColorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        selectImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            selectImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            selectImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            selectImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
        ])
    }
}
