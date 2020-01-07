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
    @IBOutlet var indicatorView: UIActivityIndicatorView!

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

    // MARK: - Properties

    private let refreshControl = UIRefreshControl()
    private var isRefreshControlRunning = false {
        didSet {
            DispatchQueue.main.async {
                self.refreshControl.isHidden = !self.isRefreshControlRunning
                if self.isRefreshControlRunning {
                    self.refreshControl.beginRefreshing()
                } else {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    private var codiListDeleteRequestCount = 0 {
        didSet {
            DispatchQueue.main.async {
                guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                if self.codiListDeleteRequestCount == 0 {
                    self.selectedIndexPath = Set<IndexPath>()
                    tabBarController.presentToastMessage("선택한 코디리스트가 삭제되었습니다.")
                    UserCommonData.shared.setIsNeedToUpdateCodiListTrue()
                    self.requestCodiListDataTask()
                }
            }
        }
    }

    private var selectedIndexPath: Set<IndexPath> = [] {
        didSet {
            if !selectedIndexPath.isEmpty, viewMode == .edit {
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

    private var isAPIDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested)
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
        RequestAPI.shared.delegate = self
        configureBasicTitle(ViewData.Title.MainTabBarView.codiList)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        viewMode = .view
        requestCodiListDataTask()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        isRefreshControlRunning = false
        isAPIDataRequested = false
        inactivateEditBarButtonItem()
        inactivateDeleteBarButtonItem()
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
        let codiListCollection = UserCommonData.shared.codiListCollection
        var selectedIdList = [Int]()
        for i in selectedIndexPath.indices {
            if selectedIndexPath[i].item >= codiListCollection.count { break }
            guard let id = codiListCollection[selectedIndexPath[i].item].id else { continue }
            selectedIdList.append(id)
        }

        // excute delete Request

        codiListDeleteRequestCount = selectedIdList.count
        guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
        for i in selectedIdList.indices {
            RequestAPI.shared.deleteAPIData(APIMode: .deleteCodiList, targetId: selectedIdList[i]) { networkError in

                self.codiListDeleteRequestCount -= 1
                if networkError != nil {
                    tabBarController.presentToastMessage("코디리스트 삭제 중 에러가 발생했습니다.")
                }
            }
        }
    }

    private func requestCodiListDataTask() {
        if UserCommonData.shared.isNeedToUpdateCodiList == false {
            return
        }

        RequestAPI.shared.getAPIData(APIMode: .getCodiList, type: [CodiListAPIData].self) { networkError, codiListCollection in
            if networkError == nil {
                guard let codiListCollection = codiListCollection else { return }
                UserCommonData.shared.configureCodiListCollection(codiListCollection)

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    UserCommonData.shared.setIsNeedToUpdateCodiListFalse()
                }
            } else {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    tabBarController.presentToastMessage("코디리스트 불러오기에 실패 했습니다.")
                    UserCommonData.shared.setIsNeedToUpdateCodiListTrue()
                }
            }
        }
    }

    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCodiListData(_:)), for: .valueChanged)
        isRefreshControlRunning = false
        collectionView.refreshControl = refreshControl
    }

    @objc func refreshCodiListData(_: UIRefreshControl) {
        isRefreshControlRunning = true
        UserCommonData.shared.setIsNeedToUpdateCodiListTrue()
        requestCodiListDataTask()
    }

    @objc func editBarButtonItemPressed(_: UIButton) {
        viewMode = viewMode == .view ? .edit : .view
    }

    @objc func deleteBarButtonItemPressed(_: UIButton) {
        presentBasicTwoButtonAlertController(title: "코디 삭제", message: "선택한 코디목록을 삭제하시겠습니까?") { isApproved in
            if isApproved {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    self.deleteSelectedCells()
                }
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
        guard let codiListCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.codiList, for: indexPath) as? CodiListCollectionViewCell else { return UICollectionViewCell() }

        let codiListData = UserCommonData.shared.codiListCollection[indexPath.item]

        codiListCell.configureCell(itemIndex: indexPath.item, codiListData: codiListData)
        return codiListCell
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if UserCommonData.shared.codiListCollection.isEmpty {
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.emptyInfoLabel.alpha = 1
            }
        } else {
            emptyInfoLabel.alpha = 0
        }

        return UserCommonData.shared.codiListCollection.count
    }
}

extension CodiListViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        isAPIDataRequested = true
    }

    func requestAPIDidFinished() {
        isAPIDataRequested = false
        isRefreshControlRunning = false
    }

    func requestAPIDidError() {
        isAPIDataRequested = false
        isRefreshControlRunning = false
    }
}

extension CodiListViewController: UIViewControllerSetting {
    func configureViewController() {
        configureRefreshControl()
        UserCommonData.shared.setIsNeedToUpdateCodiListTrue()
        tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
