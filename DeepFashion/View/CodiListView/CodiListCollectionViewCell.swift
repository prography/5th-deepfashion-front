//
//  CodiListCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiListCollectionViewCell: UICollectionViewCell {
    // MARK: UIs

    @IBOutlet var imageViewList: [UIImageView]!
    @IBOutlet var titleLabel: UILabel!

    // MARK: Properties

    private var selectEffectView: UIView = {
        let selectEffectView = UIView()
        selectEffectView.backgroundColor = .white
        selectEffectView.layer.borderColor = ViewData.Color.border
        selectEffectView.layer.borderWidth = 1
        selectEffectView.alpha = 0.7
        selectEffectView.isHidden = true
        return selectEffectView
    }()

    override var isSelected: Bool {
        didSet {
            self.selectEffectView.isHidden = !isSelected
        }
    }

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        addSubviews()
        layer.borderColor = ViewData.Color.border
        layer.cornerRadius = 10
        layer.borderWidth = 3

        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 3

        for i in imageViewList.indices {
            imageViewList[i].backgroundColor = .lightGray
            imageViewList[i].image = UIImage(named: AssetIdentifier.Image.noClothing)
            imageViewList[i].clipsToBounds = true
            imageViewList[i].layer.cornerRadius = 5
        }

        selectEffectView.bounds = bounds
        selectEffectView.center = center
        makeConstraints()
    }

    private func configureCodiListImage(_ idList: [Int]) {
        if idList.isEmpty { return }
        guard let defaultImage = UIImage(named: AssetIdentifier.Image.noClothing) else { return }
        let sortedIdList = idList.sorted()
        var idListIndex = 0
        let clothingAPIDataList = UserCommonData.shared.clothingDataList.sorted()
        for i in clothingAPIDataList.indices {
            if idListIndex >= sortedIdList.count { break }
            if clothingAPIDataList[i].id == sortedIdList[idListIndex] {
                let clientIndex = ClothingCategoryIndex.shared.convertToMainClientIndex(clothingAPIDataList[i].part)
                imageViewList[clientIndex].setThumbnailImageFromServerURL(clothingAPIDataList[i].image, placeHolder: defaultImage)
                idListIndex += 1
            }
        }
    }

    // MARK: Methods

    func configureCell(itemIndex _: Int, codiListData: CodiListAPIData) {
        guard let createdTime = codiListData.createdTime else { return }
        let createTime = Array(createdTime)[0 ..< 10]
        var titleText = "now codiList Name : "
        titleText += "\(codiListData.name)"
        titleText += "\n\(String(createTime))"
        titleText += "\nnow codiList Ids : "
        for i in codiListData.clothes.indices {
            titleText += "#\(codiListData.clothes[i]) "
        }

        configureCodiListImage(codiListData.clothes)
//        let nowDateText = basicDateFormatter.basicFormatString(timeStamp: codiDataSet.timeStamp)
//
        titleLabel.text = titleText
    }

    private func addSubviews() {
        addSubview(selectEffectView)
    }

    private func makeConstraints() {
        selectEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectEffectView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            selectEffectView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            selectEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            selectEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
}
