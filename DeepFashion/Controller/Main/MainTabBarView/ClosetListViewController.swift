//
//  ClosetListViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListViewController: UIViewController {
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var closetListTableView: UITableView!

    private var editBarButtonItem: UIBarButtonItem = {
        let editBarButtonItem = UIBarButtonItem()
        editBarButtonItem.title = "편집"
        return editBarButtonItem
    }()

    private var deleteBarButtonItem: UIBarButtonItem = {
        let deleteBarButtonItem = UIBarButtonItem()
        deleteBarButtonItem.isEnabled = false
        deleteBarButtonItem.title = "삭제"
        return deleteBarButtonItem
    }()

    private var selectedClothingData = Set<UserClothingData>() {
        didSet {
            if !selectedClothingData.isEmpty {
                deleteBarButtonItem.isEnabled = true
            } else {
                deleteBarButtonItem.isEnabled = false
            }
        }
    }

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
                editBarButtonItem.title = "편집"
            case .edit:
                activateDeleteBarButtonItem()
                editBarButtonItem.title = "취소"
            }
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        viewMode = .view
        DispatchQueue.main.async {
            self.closetListTableView.reloadData()
        }
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        inactivateEditBarButtonItem()
        inactivateDeleteBarButtonItem()
    }

    // MARK: Methods

    private func activateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = editBarButtonItem
        editBarButtonItem.isEnabled = true
        editBarButtonItem.addTargetForAction(target: self, action: #selector(editBarButtonItemPressed(_:)))
    }

    private func activateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = deleteBarButtonItem

        deleteBarButtonItem.addTargetForAction(target: self, action: #selector(deleteBarButtonItemPressed(_:)))

        for section in 0 ..< 4 {
            guard let closetTableCell = closetListTableView.cellForRow(at: IndexPath(row: 0, section: section)) as? ClosetListTableViewCell else { return }
            closetTableCell.collectionView.allowsMultipleSelection = true
        }
    }

    private func inactivateEditBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.rightBarButtonItem = nil
    }

    private func inactivateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = nil

        for section in 0 ..< 4 {
            guard let closetTableCell = closetListTableView.cellForRow(at: IndexPath(row: 0, section: section)) as? ClosetListTableViewCell else { return }
            closetTableCell.collectionView.allowsSelection = false
        }
    }

    @objc func editBarButtonItemPressed(_: UIButton) {
        if viewMode == .view {
            viewMode = .edit
        } else {
            viewMode = .view
        }
    }

    @objc func deleteBarButtonItemPressed(_: UIButton) {}
}

extension ClosetListViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 30
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fashionType = FashionType(rawValue: section)
        guard let headerViewTitleText = fashionType?.title else { return UIView() }

        let closetListTableHeaderView = ClosetListTableHeaderView()
        closetListTableHeaderView.configureTitleLabel(headerViewTitleText)
        return closetListTableHeaderView
    }
}

extension ClosetListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let closetListTableViewCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.closetList, for: indexPath) as? ClosetListTableViewCell else { return UITableViewCell() }
        let clothingData = CommonUserData.shared.clothingList.filter { $0.fashionType == indexPath.section }
        closetListTableViewCell.delegate = self
        closetListTableViewCell.configureCell(clothingData: clothingData)
        return closetListTableViewCell
    }
}

extension ClosetListViewController: ClosetListTableViewCellDelegate {
    func subCollectionViewCellSelected(collectionView: ClosetListCollectionViewCell) {
        guard let cellClothingData = collectionView.clothingData else { return }
        if collectionView.isSelected {
            print("선택 됨 ^-^")
            selectedClothingData.insert(cellClothingData)
        } else {
            print("선택 해제 됨 x_x")
            selectedClothingData.remove(cellClothingData)
        }
        print(selectedClothingData)
    }
}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.closetListView)
        closetListTableView.delegate = self
        closetListTableView.dataSource = self
    }
}
