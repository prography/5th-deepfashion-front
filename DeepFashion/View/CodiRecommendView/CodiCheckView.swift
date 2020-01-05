//
//  CodiCheckView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/05.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiCheckView: UIView {
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), collectionViewLayout: CodiRecommendCollectionViewFlowLayout())
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 5
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.white.cgColor
        collectionView.register(CodiCheckCollectionViewCell.self, forCellWithReuseIdentifier: UIIdentifier.Cell.CollectionView.codiCheck)
        return collectionView
    }()

    var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.white.cgColor
        titleTextField.backgroundColor = .white
        titleTextField.placeholder = " 코디 이름을 설정해주세요."
        return titleTextField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorList.beige
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addSubviews() {
        addSubview(collectionView)
        addSubview(titleTextField)
    }

    func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: titleTextField.topAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.0),
        ])

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            titleTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            titleTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 35),
            titleTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
}
