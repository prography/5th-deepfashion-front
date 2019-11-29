//
//  FashionStyleSelectViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/29.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class EditStyleViewController: UIViewController {
    // MARK: - UIs

    @IBOutlet var styleCollectionView: UICollectionView!

    // MARK: - Properties

    private var fashionStyles: [String] = {
        var fashionStyles = [String]()
        fashionStyles = CommonUserData.shared.gender == 0 ? FashionStyle.male : FashionStyle.Female
        return fashionStyles
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        styleCollectionView.delegate = self
        styleCollectionView.dataSource = self
    }

    // MARK: Methods

    // MARK: - IB Methods

    @IBAction func finishButtonPressed(_: UIButton) {
        print("Finish Button Pressed!!")

        navigationController?.popViewController(animated: true)
    }

    @IBAction func CancelButtonPressed(_: UIButton) {
        print("Cancel Button Pressed!!")
        navigationController?.popViewController(animated: true)
    }
}

// 셀의 크기, 행 별 갯수를 지정하기 위한 UICollectionViewDelegateFlowLayout 프로토콜 채택
extension EditStyleViewController: UICollectionViewDelegateFlowLayout {}

extension EditStyleViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)th Item Cell Pressed!!")
    }
}

extension EditStyleViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return fashionStyles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? FashionStyleSelectCollectionViewCell else { return UICollectionViewCell() }
        styleTitleCell.configureCell(fashionStyles[indexPath.item])

        return styleTitleCell
    }
}
