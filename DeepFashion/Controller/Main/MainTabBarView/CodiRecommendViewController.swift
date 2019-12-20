//
//  HomeViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiRecommendViewController: UIViewController {
    // MARK: UIs

    @IBOutlet var codiListSaveButton: UIButton!
    @IBOutlet var recommendCollectionView: UICollectionView!

    // MARK: Properties

    private let clothingPartTitle = [" Top", " Outer", " Bottom", " Shoes"]
    private var codiIdCount = 0

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        // configureClothingInfoViewTitle()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }

    // MARK: Methods

    private func configureCodiListSaveButton() {
        codiListSaveButton.isEnabled = true
    }

    private func addCodiDataSet() {
        var codiDataSet = [CodiData]()
        for i in 0 ..< 4 {
            let nowIndexPath = IndexPath(item: i, section: 0)
            guard let nowCell = recommendCollectionView.cellForItem(at: nowIndexPath) as? CodiRecommendCollectionViewCell else { return }
            let codiData = CodiData(codiImage: nowCell.imageView.image, codiId: codiIdCount)
            codiDataSet.append(codiData)
            if codiDataSet.count == 4 { break }
        }
        CommonUserData.shared.addCodiData(codiDataSet)
        print("codiDataSet Added!!")
        codiIdCount += 1
    }

    // MARK: - IBAction

    @IBAction func saveButtonPressed(_: UIButton) {
        presentBasicTwoButtonAlertController(title: "코디 저장", message: "해당 코디를 저장하시겠습니까?") { isApproved in
            if isApproved {
                self.addCodiDataSet()
            }
        }
    }
}

extension CodiRecommendViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        print("didSelect!!")
    }

    func collectionView(_: UICollectionView, didDeselectItemAt _: IndexPath) {
        print("diddeSelect!!")
    }
}

extension CodiRecommendViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return ViewData.Title.fashionType.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codiRecommendCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.recommend, for: indexPath) as? CodiRecommendCollectionViewCell else { return UICollectionViewCell() }
        codiRecommendCollectionCell.configureCell(title: ViewData.Title.fashionType[indexPath.item])
        return codiRecommendCollectionCell
    }
}

extension CodiRecommendViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.homeView)
        configureCodiListSaveButton()
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.allowsMultipleSelection = true
    }
}
