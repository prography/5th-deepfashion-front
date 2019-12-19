//
//  CodiListViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiListViewController: UIViewController {
    // MARK: UIs

    @IBOutlet var codiListCollectionView: UICollectionView!

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

    // MARK: Properties

    enum ViewMode {
        case view
        case edit
    }

    var viewMode: ViewMode = .view {
        didSet {
            switch viewMode {
            case .view:
                inactivateDeleteBarButtonItem()
                activateEditBarButtonItem()
                editBarButtonItem.title = "선택"
            case .edit:
                activateDeleteBarButtonItem()
                editBarButtonItem.title = "취소"
                // removeAll()
            }
        }
    }

    private var selectedIndexPath: Set<IndexPath> = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
        viewMode = .view
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        inactivateEditBarButtonItem()
        inactivateDeleteBarButtonItem()
    }

    private func activateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = editBarButtonItem
        editBarButtonItem.isEnabled = true
        editBarButtonItem.addTargetForAction(target: self, action: #selector(editBarButtonItemPressed(_:)))
    }

    private func activateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = deleteBarButtonItem
        deleteBarButtonItem.isEnabled = true
        deleteBarButtonItem.addTargetForAction(target: self, action: #selector(deleteBarButtonItemPressed(_:)))
        codiListCollectionView.allowsSelection = false
        codiListCollectionView.allowsMultipleSelection = true
    }

    private func inactivateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = nil
    }

    private func inactivateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = nil
        codiListCollectionView.allowsSelection = false
        codiListCollectionView.allowsMultipleSelection = false
    }

    @objc func editBarButtonItemPressed(_: UIButton) {
        print("editBarButtonItemPressed!")
        viewMode = viewMode == .view ? .edit : .view
    }

    @objc func deleteBarButtonItemPressed(_: UIButton) {
        print("deleteBarButtonItemPressed")
        codiListCollectionView.performBatchUpdates({
            var idexPathArray = [IndexPath]()
            selectedIndexPath.forEach { idexPathArray.append($0) }
            codiListCollectionView.deleteItems(at: idexPathArray)
            selectedIndexPath = Set<IndexPath>()
        })
    }
}

extension CodiListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("now item: \(indexPath.item)")
        selectedIndexPath.insert(indexPath)
        print(selectedIndexPath)
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPath.remove(indexPath)
        print(selectedIndexPath)
    }
}

extension CodiListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return CommonUserData.shared.codiListData.count
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
