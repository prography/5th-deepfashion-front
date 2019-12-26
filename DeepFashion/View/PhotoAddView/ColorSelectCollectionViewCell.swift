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

//    private let selectImageView: UIImageView = {
//        let selectImageView = UIImageView()
//        selectImageView.image = UIImage(named: AssetIdentifier.Image.longJacket)
//        selectImageView.contentMode = .scaleAspectFill
//        return selectImageView
//    }()

    private let mixedColorImageView: UIImageView = {
        let mixedColorImageView = UIImageView()
        mixedColorImageView.contentMode = .scaleAspectFill
        mixedColorImageView.image = UIImage(named: AssetIdentifier.Image.mixedColor)
        return mixedColorImageView
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
    }

    // MARK: Methodss

    func configureCell(rgb: UInt64) {
        addSubviews()
        makeConstraints()
        configureCellColor(rgb: rgb)
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
        clipsToBounds = true
    }

    private func configureCellColor(rgb: UInt64) {
        if rgb == 0x181818 {
            mixedColorImageView.isHidden = false
            mixedColorImageView.clipsToBounds = true
        } else {
            mixedColorImageView.isHidden = true
            let cellColor = UIColor(rgb: rgb, alpha: 1.0)
            backgroundColor = cellColor
        }
    }

    private func addSubviews() {
        contentView.addSubview(mixedColorImageView)
//        addSubview(selectImageView)
    }

    private func makeConstraints() {
        mixedColorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mixedColorImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            mixedColorImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            mixedColorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            mixedColorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        //        selectImageView.translatesAutoresizingMaskIntoConstraints = false
        //        NSLayoutConstraint.activate([
        //            selectImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
        //            selectImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
        //            selectImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        //            selectImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        //        ])
    }
}
