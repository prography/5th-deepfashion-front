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

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyInfoLabel: UILabel!

    private var editBarButtonItem: UIBarButtonItem = {
        let editBarButtonItem = UIBarButtonItem()
        editBarButtonItem.title = "편집"
        return editBarButtonItem
    }()

    private var deleteBarButtonItem: UIBarButtonItem = {
        let deleteBarButtonItem = UIBarButtonItem()
        deleteBarButtonItem.isEnabled = false
        deleteBarButtonItem.image = UIImage(named: AssetIdentifier.Image.delete)
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
                editBarButtonItem.image = UIImage(named: AssetIdentifier.Image.edit)
            case .edit:
                activateDeleteBarButtonItem()
                editBarButtonItem.image = UIImage(named: AssetIdentifier.Image.cancel)
            }
        }
    }

    private var selectedIndexPath: Set<IndexPath> = [] {
        didSet {
            if !selectedIndexPath.isEmpty, viewMode == .edit {
                self.deleteBarButtonItem.isEnabled = true
            } else {
                self.deleteBarButtonItem.isEnabled = false
            }
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        collectionView.delegate = self
        collectionView.dataSource = self
        editBarButtonItem.addTargetForAction(target: self, action: #selector(CodiListViewController.editBarButtonItemPressed(_:)))
        deleteBarButtonItem.addTargetForAction(target: self, action: #selector(CodiListViewController.deleteBarButtonItemPressed(_:)))
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureBasicTitle(ViewData.Title.MainTabBarView.codiList)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        viewMode = .view
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        inactivateEditBarButtonItem()
        inactivateDeleteBarButtonItem()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func activateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = editBarButtonItem
        editBarButtonItem.isEnabled = true
    }

    private func activateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = deleteBarButtonItem
        collectionView.allowsMultipleSelection = true
    }

    private func inactivateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = nil
    }

    private func inactivateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = nil
        collectionView.allowsSelection = false
    }

    private func deleteSelectedCells() {
        var originCodiDataList = UserCommonData.shared.codiDataList
        selectedIndexPath.forEach {
            originCodiDataList[$0.item] = nil
        }

        originCodiDataList = originCodiDataList.filter { $0 != nil }
        guard let codiDataList = originCodiDataList as? [CodiDataSet] else { return }
        UserCommonData.shared.configureCodiDataList(codiDataList)
        selectedIndexPath = Set<IndexPath>()

        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems else { return }

        if !selectedIndexPath.isEmpty {
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: selectedIndexPath)
            }, completion: nil)
        }
    }

    @objc func editBarButtonItemPressed(_: UIButton) {
        viewMode = viewMode == .view ? .edit : .view
    }

    @objc func deleteBarButtonItemPressed(_: UIButton) {
        guard let tabBarController = self.tabBarController else { return }
        presentBasicTwoButtonAlertController(title: "코디 삭제", message: "선택한 코디목록을 삭제하시겠습니까?") { isApproved in
            if isApproved {
                ToastView.shared.presentShortMessage(tabBarController.view, message: "선택한 코디목록이 삭제되었습니다!")
                self.deleteSelectedCells()
            }
        }
    }
}

extension CodiListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath.insert(indexPath)
    }

    func collectionView(_: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPath.remove(indexPath)
    }
}

extension CodiListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codiListCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.codiList, for: indexPath) as? CodiListCollectionViewCell,
            let codiDataSet = UserCommonData.shared.codiDataList[indexPath.item] else { return UICollectionViewCell() }

        codiListCell.configureCell(itemIndex: indexPath.item, codiDataSet: codiDataSet)
        return codiListCell
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if UserCommonData.shared.codiDataList.isEmpty {
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.emptyInfoLabel.alpha = 1
            }
        } else {
            emptyInfoLabel.alpha = 0
        }

        return UserCommonData.shared.codiDataList.count
    }
}

extension CodiListViewController: UIViewControllerSetting {
    func configureViewController() {
        tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
