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
        selectEffectView.layer.borderColor = ViewData.Color.borderColor
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
        layer.borderColor = ViewData.Color.borderColor
        layer.cornerRadius = 10
        layer.borderWidth = 3

        titleLabel.text = "# CodiList Title"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        for i in imageViewList.indices {
            imageViewList[i].backgroundColor = .lightGray
            imageViewList[i].image = UIImage(named: AssetIdentifier.Image.longJacket)
            imageViewList[i].clipsToBounds = true
            imageViewList[i].layer.cornerRadius = 5
        }

        selectEffectView.bounds = bounds
        selectEffectView.center = center
        makeConstraints()
    }

    // MARK: Methods

    func configureCell(itemIndex _: Int, codiDataSet: CodiDataSet) {
        let basicDateFormatter = DateFormatter()
        let nowDateText = basicDateFormatter.basicFormatString(timeStamp: codiDataSet.timeStamp)

        titleLabel.text = "\(nowDateText) \n # \(codiDataSet.dataSet[0].codiId) Id codiDataSet"
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
