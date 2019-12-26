//
//  FashionStyleSelectViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/29.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class EditStyleViewController: UIViewController {
    // MARK: UIs

    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet var subscriptionButton: UIButton!

    // MARK: Properties

    private var fashionStyles: [String] = {
        var fashionStyles = [String]()
        fashionStyles = UserCommonData.shared.gender == 0 ? FashionStyle.male : FashionStyle.female
        return fashionStyles
    }()

    var selectedStyle: (String, Int) = ("", 0)

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        subscriptionButton.isEnabled = false
        configureFashionStyleIndex()
        configureSelectedStyleCount()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: Methods

    private func configureSelectedStyleCount() {}

    private func configureFashionStyleIndex() {}

    // MARK: - IBActions

    @IBAction func finishButtonPressed(_: UIButton) {
        print("Finish Button Pressed!!")
        UserCommonData.shared.resetStyleData()
        guard let navigationController = self.navigationController,
            let addFashionViewController = self.navigationController?.viewControllers[navigationController.viewControllers.count - 2] as? EditClothingViewController,
            let selectedItem = collectionView.indexPathsForSelectedItems else { return }
        addFashionViewController.selectedFashionData.style = (fashionStyles[selectedItem[0].item], selectedItem[0].item)
        addFashionViewController.refreshStyleButton()

        navigationController.popViewController(animated: true)
    }

    @IBAction func CancelButtonPressed(_: UIButton) {
        print("Cancel Button Pressed!!")
        navigationController?.popViewController(animated: true)
    }
}

// 셀의 크기, 행 별 갯수를 지정하기 위한 UICollectionViewDelegateFlowLayout 프로토콜 채택
extension EditStyleViewController: UICollectionViewDelegateFlowLayout {}

extension EditStyleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)th Item Cell Pressed!!")
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? editStyleCollectionViewCell else { return }
        subscriptionButton.isEnabled = true
        if styleTitleCell.styleTitleLabel.text == "" { return }
        selectedStyle = (fashionStyles[indexPath.item], indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            return false
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        return true
    }
}

extension EditStyleViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return fashionStyles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? editStyleCollectionViewCell else { return UICollectionViewCell() }

        let isSelected = indexPath.item == selectedStyle.1 ? true : false
        styleTitleCell.configureCell(style: (fashionStyles[indexPath.item], indexPath.item), isSelected: isSelected)

        return styleTitleCell
    }
}
