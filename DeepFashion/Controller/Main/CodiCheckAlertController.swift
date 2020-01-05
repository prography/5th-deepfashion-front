//
//  CodiCheckAlertController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/05.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiCheckAlertController: UIAlertController {
    private let codiCheckView: CodiCheckView = {
        let codiCheckView = CodiCheckView(frame: CGRect.zero)
        return codiCheckView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCodiCheckView()
        addSubviews()
        makeConstraints()

        let addAlertAction = UIAlertAction(title: "코디 추가하기", style: .default, handler: nil)
        let cancelAlertAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        addAction(addAlertAction)
        addAction(cancelAlertAction)
    }

    private func configureCodiCheckView() {
        codiCheckView.collectionView.dataSource = self
        codiCheckView.collectionView.delegate = self
    }

    private func configureView() {
        guard let mainView = self.view else { return }
        let viewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint(item: mainView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.height * 0.60)
        view.addConstraint(viewHeightAnchor)
    }

    private func addSubviews() {
        view.addSubview(codiCheckView)
    }

    private func makeConstraints() {
        codiCheckView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            codiCheckView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            codiCheckView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            codiCheckView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            codiCheckView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
        ])
    }
}

extension CodiCheckAlertController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codiCheckCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.codiCheck, for: indexPath) as? CodiCheckCollectionViewCell else { return UICollectionViewCell() }
        return codiCheckCollectionCell
    }
}

extension CodiCheckAlertController: UICollectionViewDelegate {}
