//
//  CodiListViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiListViewController: UIViewController {
    private var editBarButtonItem: UIBarButtonItem = {
        let editBarButtonItem = UIBarButtonItem()
        editBarButtonItem.title = "편집"
        return editBarButtonItem
    }()

    private var deleteBarButtonItem: UIBarButtonItem = {
        let deleteBarButtonItem = UIBarButtonItem()
        deleteBarButtonItem.title = "삭제"
        return deleteBarButtonItem
    }()

    // MARK: - Life Cycle

    @IBOutlet var codiListCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
        activateEditBarButtonItem()
        activateDeleteBarButtonItem()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        inactivateBarButtonItems()
    }

    private func activateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        editBarButtonItem.isEnabled = true
        mainTabBarController.navigationItem.rightBarButtonItem = editBarButtonItem
        editBarButtonItem.addTargetForAction(target: self, action: #selector(editBarButtonItemPressed(_:)))
    }

    private func activateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        deleteBarButtonItem.isEnabled = true
        mainTabBarController.navigationItem.leftBarButtonItem = deleteBarButtonItem
        deleteBarButtonItem.addTargetForAction(target: self, action: #selector(deleteBarButtonItemPressed(_:)))
    }

    private func inactivateBarButtonItems() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = nil
    }

    @objc func editBarButtonItemPressed(_: UIButton) {
        print("editBarButtonItemPressed!")
    }

    @objc func deleteBarButtonItemPressed(_: UIButton) {
        print("deleteBarButtonItemPressed")
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
        codiListCollectionView.delegate = self
        codiListCollectionView.dataSource = self
        configureBasicTitle(ViewData.Title.MainTabBarView.codiListView)
        tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
