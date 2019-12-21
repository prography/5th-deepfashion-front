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
        fashionStyles = CommonUserData.shared.gender == 0 ? FashionStyle.male : FashionStyle.female
        return fashionStyles
    }()

    var selectedStyleIndex: [(String, Int)] = []

    private var selectedStyleCount: Int = 0 {
        willSet {
            if newValue == 0 {
                subscriptionButton.isEnabled = false
            } else {
                subscriptionButton.isEnabled = true
            }
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        configureFashionStyleIndex()
        configureSelectedStyleCount()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        guard let navigationController = self.navigationController,
            let addFashionViewController = self.navigationController?.viewControllers[navigationController.viewControllers.count - 2] as? AddFashionViewController else { return }
        addFashionViewController.selectedFashionData.style = selectedStyleIndex
    }

    // MARK: Methods

    private func configureSelectedStyleCount() {
        for i in selectedStyleIndex.indices {
            if selectedStyleIndex[i].1 == 1 { selectedStyleCount += 1 }
        }
    }

    private func configureFashionStyleIndex() {
        for i in fashionStyles.indices {
            selectedStyleIndex.append((fashionStyles[i], 0))
            if i == 0 { selectedStyleIndex[i].1 = 1 }
        }
    }

    // MARK: - IBActions

    @IBAction func finishButtonPressed(_: UIButton) {
        print("Finish Button Pressed!!")
        CommonUserData.shared.resetStyleData()
        guard let viewControllers = navigationController?.viewControllers,
            let addFashionViewControlller = navigationController?.viewControllers[viewControllers.count - 2] as? AddFashionViewController else { return }
        addFashionViewControlller.selectedFashionData.style = selectedStyleIndex
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
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? StyleSelectCollectionViewCell else { return }
        if styleTitleCell.styleTitleLabel.text == "" { return }

        if styleTitleCell.toggleCell(styles: &selectedStyleIndex, itemIndex: indexPath.item) {
            selectedStyleCount += 1
        } else {
            selectedStyleCount -= 1
        }

        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
        }

        print(selectedStyleCount)
        print(selectedStyleIndex)
    }

//    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard let styleTitleCell = styleCollectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? FashionStyleSelectCollectionViewCell else { return }
//        if styleTitleCell.styleTitleLabel.text == "" { return }
//
//        DispatchQueue.main.async {
//            self.styleCollectionView.reloadItems(at: [indexPath])
//        }
//
//        print(selectedStyleIndex)
//        print("selectedStyleCount : \(selectedStyleCount)")
//    }
}

extension EditStyleViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return fashionStyles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let styleTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.styleTitle, for: indexPath) as? StyleSelectCollectionViewCell else { return UICollectionViewCell() }

        styleTitleCell.configureCell(style: selectedStyleIndex[indexPath.item])

        return styleTitleCell
    }
}
