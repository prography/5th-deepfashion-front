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
        selectEffectView.layer.borderColor = ColorList.brownish?.cgColor
        selectEffectView.layer.borderWidth = 1
        selectEffectView.alpha = 0.7
        selectEffectView.isHidden = true
        return selectEffectView
    }()

    private var lockImageView: UIImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = UIImage(named: AssetIdentifier.Image.lockIcon)
        lockImageView.contentMode = .scaleAspectFill
        return lockImageView
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
        layer.borderColor = ViewData.Color.borderColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        configureTitleLabel()
        addSubviews()
        makeConstraints()
    }

    // MARK: Methods

    private func configureTitleLabel() {
        titleLabel.font = UIFont.subFont(displaySize: 18)
        titleLabel.textColor = .white
        titleLabel.backgroundColor = ColorList.newBrown
    }

    func configureCell(title: String, clothingData: ClothingAPIData?, indexPath: IndexPath) {
        titleLabel.text = " \(title)"

        guard let clothingData = clothingData else {
            imageView.image = #imageLiteral(resourceName: "noClothing")
            return
        }

        let nowPartIndex = ClothingCategoryIndex.shared.convertToMainClientIndex(clothingData.part)

        if nowPartIndex == indexPath.item {
            imageView.setThumbnailImageFromServerURL(clothingData.image, placeHolder: #imageLiteral(resourceName: "noClothing"))
        }
    }

    private func addSubviews() {
        addSubview(selectEffectView)
        selectEffectView.addSubview(lockImageView)
    }

    private func makeConstraints() {
        selectEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.selectEffectView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.selectEffectView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.selectEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.selectEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])

        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lockImageView.topAnchor.constraint(equalTo: selectEffectView.topAnchor, constant: 5),
            lockImageView.rightAnchor.constraint(equalTo: selectEffectView.rightAnchor, constant: -5),
            lockImageView.widthAnchor.constraint(equalToConstant: 30),
            lockImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
