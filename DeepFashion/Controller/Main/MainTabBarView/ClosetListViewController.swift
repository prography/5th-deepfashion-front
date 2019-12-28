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
        deleteBarButtonItem.image = UIImage(named: AssetIdentifier.Image.delete)
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
                editBarButtonItem.image = UIImage(named: AssetIdentifier.Image.edit)
            case .edit:
                activateDeleteBarButtonItem()
                editBarButtonItem.image = UIImage(named: AssetIdentifier.Image.cancel)
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
        configureBasicTitle(ViewData.Title.MainTabBarView.closetList)
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
        editBarButtonItem.addTargetForAction(target: self, action: #selector(closetListEditBarButtonItemPressed(_:)))
    }

    private func activateDeleteBarButtonItem() {
        guard let mainTabBarController = self.tabBarController as? MainTabBarController else { return }
        mainTabBarController.navigationItem.leftBarButtonItem = deleteBarButtonItem

        deleteBarButtonItem.addTargetForAction(target: self, action: #selector(closetListDeleteBarButtonItemPressed(_:)))

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

    @objc func closetListEditBarButtonItemPressed(_: UIButton) {
        if viewMode == .view {
            viewMode = .edit
        } else {
            viewMode = .view
        }
    }

    @objc func closetListDeleteBarButtonItemPressed(_: UIButton) {
        guard let tabBarController = self.tabBarController else { return }
        presentBasicTwoButtonAlertController(title: "선택 옷 삭제", message: "선택한 옷을 삭제하시겠습니까?") { isApproved in

            if isApproved {
                for i in 0 ... 3 {
                    guard let closetListTableCell = self.closetListTableView.cellForRow(at: IndexPath(row: 0, section: i)) as? ClosetListTableViewCell else { return }
                    closetListTableCell.removeSelectedCollectionViewCell { isSucceed in
                        if isSucceed {
                            ToastView.shared.presentShortMessage(tabBarController.view, message: "선택한 옷이 삭제되었습니다!")
                        }
                    }
                }

                UserCommonData.shared.removeClothingData(selectedData: self.selectedClothingData)
                self.deleteBarButtonItem.isEnabled = false
            }
        }
    }
}

extension ClosetListViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return ViewData.Row.Height.closetList
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
        let clothingData = UserCommonData.shared.clothingList.filter { $0.fashionType == indexPath.section }
        closetListTableViewCell.delegate = self
        closetListTableViewCell.configureCell(clothingData: clothingData)
        return closetListTableViewCell
    }
}

extension ClosetListViewController: ClosetListTableViewCellDelegate {
    func subCollectionViewCellSelected(collectionView: ClosetListCollectionViewCell) {
        guard let cellClothingData = collectionView.clothingData else { return }
        if collectionView.isSelected {
            selectedClothingData.insert(cellClothingData)
        } else {
            selectedClothingData.remove(cellClothingData)
        }
        print(selectedClothingData)
    }
}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        closetListTableView.delegate = self
        closetListTableView.dataSource = self
        closetListTableView.allowsSelection = false
    }
}
