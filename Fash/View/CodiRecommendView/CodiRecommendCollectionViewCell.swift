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
    @IBOutlet var clothingImageView: UIImageView!
    @IBOutlet var titleLockImageView: UIImageView!
    private(set) var clothingData: ClothingAPIData?

    private var selectEffectView: UIView = {
        let selectEffectView = UIView()
        selectEffectView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        selectEffectView.isHidden = true
        return selectEffectView
    }()

    private var selectEffectImageView: UIImageView = {
        let selectEffectImageView = UIImageView()
        selectEffectImageView.image = UIImage(named: "selectLock.png")
        selectEffectImageView.backgroundColor = .clear
        return selectEffectImageView
    }()

    private var lockImageView: UIImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = UIImage(named: AssetIdentifier.Image.lockIcon)
        lockImageView.contentMode = .scaleAspectFill
        return lockImageView
    }()

    override var isSelected: Bool {
        didSet {
            self.titleLockImageView.isHidden = isSelected
            self.selectEffectView.isHidden = !isSelected
        }
    }

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        configureTitleLabel()
        addSubviews()
        makeConstraints()
    }

    // MARK: Methods

    private func configureTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
//        configureTitleLockImage()
    }

//    private func configureTitleLockImage() {
//
//    }

    func updateCellImage(_ imageURLString: String?) {
        guard let defaultImage = UIImage(named: AssetIdentifier.Image.noClothing) else { return }
        clothingImageView.setThumbnailImageFromServerURL(imageURLString, placeHolder: defaultImage)
    }

    func configureCell(title: String, clothingData: ClothingAPIData?, indexPath: IndexPath) {
        titleLabel.text = " # \(title)"

        guard let defaultImage = UIImage(named: AssetIdentifier.Image.noClothing) else { return }
        guard let clothingData = clothingData else {
            clothingImageView.image = defaultImage
            return
        }

        let nowPartIndex = ClothingIndex.shared.convertToMainClientIndex(clothingData.part)

        if nowPartIndex == indexPath.item {
            clothingImageView.setThumbnailImageFromServerURL(clothingData.image, placeHolder: defaultImage)
        } else {
            clothingImageView.image = defaultImage
        }
    }

    private func addSubviews() {
        addSubview(selectEffectView)
        selectEffectView.addSubview(selectEffectImageView)
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

        selectEffectImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectEffectImageView.centerXAnchor.constraint(equalTo: selectEffectView.centerXAnchor),
            selectEffectImageView.centerYAnchor.constraint(equalTo: selectEffectView.centerYAnchor),
            selectEffectImageView.widthAnchor.constraint(equalToConstant: 30),
            selectEffectImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
