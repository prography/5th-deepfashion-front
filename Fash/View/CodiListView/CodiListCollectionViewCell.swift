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
        selectEffectView.layer.borderColor = ColorList.mainBorder
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

        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5

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
        var imageCheckList = [Int](repeating: 0, count: 4)
        let clothingAPIDataList = UserCommonData.shared.clothingDataList.sorted()

        if idListIndex < sortedIdList.count {
            clothingAPIDataList
                .filter { $0.id == sortedIdList[idListIndex] }
                .forEach { data in
                    let clientIndex = ClothingIndex.shared.convertToMainClientIndex(data.part)
                    imageViewList[clientIndex].setThumbnailImageFromServerURL(data.image, placeHolder: defaultImage)
                    imageCheckList[clientIndex] = 1
                    idListIndex += 1
                }
        }

        imageCheckList.enumerated()
            .filter { $0.element == 0 }
            .forEach { self.imageViewList[$0.offset].image = defaultImage }
    }

    // MARK: Methods

    func configureCell(itemIndex _: Int, codiListData: CodiListAPIData) {
        guard let createdTime = codiListData.createdTime else { return }
        let createTime = Array(createdTime)[0 ..< 10]
        var titleText = ""
        titleText += "\(codiListData.name)"
        titleText += "\n\(String(createTime))"

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
