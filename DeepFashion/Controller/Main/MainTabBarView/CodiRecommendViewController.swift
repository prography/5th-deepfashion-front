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
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var refreshCodiButton: UIButton!
    @IBOutlet var leftTitleView: UIView!

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
        codiListSaveButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        codiListSaveButton.setTitle("코디 저장하기", for: .normal)
        codiListSaveButton.configureEnabledButton()
    }

    private func configureRefreshCodiButton() {
        refreshCodiButton.backgroundColor = ColorList.newBrown
        refreshCodiButton.setTitleColor(.white, for: .normal)
        refreshCodiButton.setTitle(" 코디 새로고침", for: .normal)
        refreshCodiButton.titleLabel?.font = UIFont.mainFont(displaySize: 12)
        refreshCodiButton.setImage(UIImage(named: AssetIdentifier.Image.refresh), for: .normal)
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
        UserCommonData.shared.addCodiData(codiDataSet)
        codiIdCount += 1
    }

    // MARK: - IBAction

    @IBAction func saveButtonPressed(_: UIButton) {
        presentBasicTwoButtonAlertController(title: "코디 저장", message: "해당 코디를 저장하시겠습니까?") { isApproved in
            if isApproved {
                guard let tabBar = self.tabBarController else { return }
                ToastView.shared.presentShortMessage(tabBar.view, message: "해당 코디가 저장되었습니다!")
                self.addCodiDataSet()
            }
        }
    }
}

extension CodiRecommendViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}

    func collectionView(_: UICollectionView, didDeselectItemAt _: IndexPath) {}
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

        configureRefreshCodiButton()
        celsiusLabel.font = UIFont.mainFont(displaySize: 18)
        celsiusLabel.adjustsFontSizeToFitWidth = true
    }
}
