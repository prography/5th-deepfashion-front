//
//  CodiListViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiListViewController: UIViewController {
    // MARK: - Life Cycle

    @IBOutlet var codiListCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        codiListCollectionView.delegate = self
        codiListCollectionView.dataSource = self
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }
}

extension CodiListViewController: UICollectionViewDelegate {}

extension CodiListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codiListCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.codiList, for: indexPath) as? CodiListCollectionViewCell else { return UICollectionViewCell() }
        codiListCell.configureCell(itemIndex: indexPath.item)
        return codiListCell
    }
}

extension CodiListViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.codiListView)
    }
}
