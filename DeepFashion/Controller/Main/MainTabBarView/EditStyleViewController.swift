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

    @IBOutlet var styleSubscriptionButton: UIButton!

    // MARK: - Properties

    private var fashionStyles: [String] = {
        var fashionStyles = [String]()
        fashionStyles = CommonUserData.shared.gender == 0 ? FashionStyle.male : FashionStyle.Female
        return fashionStyles
    }()

    private var selectedStyleIndex: [(String, Int)] = {
        var selectedStyleIndex = [(String, Int)]()
        return selectedStyleIndex
    }()

    private var selectedStyleCount: Int = 0 {
        willSet {
            if newValue == 0 {
                styleSubscriptionButton.isEnabled = false
            } else {
                styleSubscriptionButton.isEnabled = true
            }
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        styleCollectionView.delegate = self
        styleCollectionView.dataSource = self
        styleCollectionView.allowsMultipleSelection = true
        configureSelectedStyleIndex()

        styleSubscriptionButton.isEnabled = false
    }

    // MARK: Methods

    func configureSelectedStyleIndex() {
        for i in fashionStyles.indices {
            selectedStyleIndex.append((fashionStyles[i], 0))
        }
    }

    // MARK: - IB Methods

    @IBAction func finishButtonPressed(_: UIButton) {
        print("Finish Button Pressed!!")
        CommonUserData.shared.resetStyleData()
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
        guard let styleTitleCell = styleCollectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? FashionStyleSelectCollectionViewCell else { return }
        if styleTitleCell.styleTitleLabel.text == "" { return }

        if styleTitleCell.toggleCell(styles: &selectedStyleIndex, itemIndex: indexPath.item) {
            selectedStyleCount += 1
        }

        print(selectedStyleCount)
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let styleTitleCell = styleCollectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? FashionStyleSelectCollectionViewCell else { return }
        if styleTitleCell.styleTitleLabel.text == "" { return }

        if !styleTitleCell.toggleCell(styles: &selectedStyleIndex, itemIndex: indexPath.item) {
            selectedStyleCount -= 1
        }

        print(selectedStyleCount)
    }
}

extension EditStyleViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return fashionStyles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? FashionStyleSelectCollectionViewCell else { return UICollectionViewCell() }
        styleTitleCell.configureCell(fashionStyles[indexPath.item], itemIndex: indexPath.item)

        return styleTitleCell
    }
}
