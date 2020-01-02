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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subscriptionButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    // MARK: Properties

    private var fashionStyles: [String] = {
        var fashionStyles = [String]()
        fashionStyles = UserCommonData.shared.gender == 0 ? ClothingStyle.male : ClothingStyle.female
        return fashionStyles
    }()

    var selectedStyle: (String, Int) = ("", 0)

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: Methods

    private func configureSelectedStyleCount() {}

    private func configureFashionStyleIndex() {}

    private func configureSubscriptionButtonDisabled() {
        subscriptionButton.configureDisabledButton()
        subscriptionButton.backgroundColor = ColorList.beige
        subscriptionButton.layer.cornerRadius = 0
        subscriptionButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }

    private func configureSubscriptionButtonEnabled() {
        subscriptionButton.configureEnabledButton()
        subscriptionButton.layer.cornerRadius = 0
        subscriptionButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
    }

    private func configureTitleLabel() {
        titleLabel.font = UIFont.subFont(displaySize: 18)
        titleLabel.textColor = ColorList.brownish
    }

    // MARK: - IBActions

    @IBAction func finishButtonPressed(_: UIButton) {
        UserCommonData.shared.resetStyleData()
        guard let navigationController = self.navigationController,
            let editClothingViewController = self.navigationController?.viewControllers[navigationController.viewControllers.count - 2] as? EditClothingViewController,
            let selectedItem = collectionView.indexPathsForSelectedItems else { return }
        editClothingViewController.selectedClothingData.style = (fashionStyles[selectedItem[0].item], selectedItem[0].item)
        editClothingViewController.refreshStyleButton()

        navigationController.popViewController(animated: true)
    }

    @IBAction func CancelButtonPressed(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// 셀의 크기, 행 별 갯수를 지정하기 위한 UICollectionViewDelegateFlowLayout 프로토콜 채택
extension EditStyleViewController: UICollectionViewDelegateFlowLayout {}

extension EditStyleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? editStyleCollectionViewCell else { return }
        configureSubscriptionButtonEnabled()
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

extension EditStyleViewController: UIViewControllerSetting {
    func configureViewController() {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        configureSubscriptionButtonDisabled()
        cancelButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        configureFashionStyleIndex()
        configureSelectedStyleCount()
        configureTitleLabel()
    }
}
