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
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: - Properties

    private let refreshControl = UIRefreshControl()
    private var isRefreshControlRunning = false {
        didSet {
            DispatchQueue.main.async {
                self.refreshControl.isHidden = !self.isRefreshControlRunning
                if self.isRefreshControlRunning {
                    self.refreshControl.beginRefreshing()
                    self.indicatorView.setAlphaZero()
                } else {
                    self.refreshControl.endRefreshing()
                    self.indicatorView.setAlphaOne()
                }
            }
        }
    }

    private var isRequestedDeleteClothingData = false
    private var deletingClotingRequestCount = 0 {
        didSet {
            isRequestedDeleteClothingData = deletingClotingRequestCount > 0 ? true : false
        }
    }

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

    private var selectedClothingData = Set<ClothingAPIData>() {
        didSet {
            if !selectedClothingData.isEmpty {
                deleteBarButtonItem.isEnabled = true
            } else {
                deleteBarButtonItem.isEnabled = false
            }
        }
    }

    private var isAPIDataRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested || self.isImageDataRequested || self.isRequestedDeleteClothingData)
            }
        }
    }

    private var isImageDataRequested: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isAPIDataRequested || self.isImageDataRequested || self.isRequestedDeleteClothingData)
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
            selectedClothingData = Set<ClothingAPIData>()
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
//        configureEmptyTitle()
        RequestAPI.shared.delegate = self
        RequestImage.shared.delegate = self
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        viewMode = .view
        requestClothingDataTask()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        isRefreshControlRunning = false
        isAPIDataRequested = false
        inactivateEditBarButtonItem()
        inactivateDeleteBarButtonItem()
//        self.navigationController?.navigationBar.isHidden = true
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

    private func reloadClosetListTableView() {
        DispatchQueue.main.async {
            self.closetListTableView.reloadData()
        }
    }

    private func requestClothingDataTask() {
        if UserCommonData.shared.isNeedToUpdateClothing == false {
            return
        }
        UserCommonData.shared.setIsNeedToUpdateClothingFalse()
        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in
            if networkError == nil {
                guard let clothingDataList = clothingDataList else { return }
                UserCommonData.shared.configureClothingData(clothingDataList)
                CodiListGenerator.shared.getNowCodiDataSet()

                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    tabBarController.reloadRecommendCollectionView(clothingDataList)
                    self.reloadClosetListTableView()
                    UserCommonData.shared.setIsNeedToUpdateClothingFalse()
                }
            } else {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
                    tabBarController.presentToastMessage("옷 정보 불러오기에 실패 했습니다.")
                    UserCommonData.shared.setIsNeedToUpdateClothingTrue()
                }
            }
        }
    }

    private func checkImageDataRequest() {
        isImageDataRequested = !RequestImage.shared.isImageKeyEmpty()
    }

    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshClothingData(_:)), for: .valueChanged)
        isRefreshControlRunning = false
        closetListTableView.refreshControl = refreshControl
    }

    @objc func refreshClothingData(_: UIRefreshControl) {
        isRefreshControlRunning = true
        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
        requestClothingDataTask()
    }

    @objc func closetListEditBarButtonItemPressed(_: UIButton) {
        if viewMode == .view {
            viewMode = .edit
        } else {
            viewMode = .view
        }
    }

    @objc func closetListDeleteBarButtonItemPressed(_: UIButton) {
        //        guard let tabBarController = self.tabBarController else { return }
        presentBasicTwoButtonAlertController(title: "선택 옷 삭제", message: "선택한 옷을 삭제하시겠습니까?") { isApproved in
            // 선택한 옷 삭제를 허용하면 삭제 요청을 진행한다.
            if isApproved {
                // 선택한 id 옷들을 delete 요청 하여 제거해야 한다.
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController else { return }
                    self.deletingClotingRequestCount = self.selectedClothingData.count
                    for selectedData in self.selectedClothingData {
                        RequestAPI.shared.deleteAPIData(APIMode: .deleteClothing, targetId: selectedData.id) { networkError in
                            DispatchQueue.main.async {
                                self.deletingClotingRequestCount -= 1
                                if networkError == nil {
                                    if self.deletingClotingRequestCount == 0 {
                                        self.closetListTableView.reloadData()
                                        ToastView.shared.presentShortMessage(tabBarController.view, message: "옷 삭제에 성공하였습니다. ")
                                        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
                                        self.requestClothingDataTask()
                                        self.endIgnoringInteractionEvents()
                                    }
                                } else {
                                    ToastView.shared.presentShortMessage(tabBarController.view, message: "옷 삭제 중 오류가 발생하였습니다.")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ClosetListViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return ViewData.Section.Row.Height.closetList
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 30
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fashionType = ClothingMainType(rawValue: section)
        guard let headerViewTitleText = fashionType?.title else { return UIView() }

        let closetListTableHeaderView = ClosetListTableHeaderView()
        closetListTableHeaderView.configureTitleLabel(" # \(headerViewTitleText)")
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

        let clothingData = UserCommonData.shared.clothingDataList.sorted().filter {
            // 받은 인덱스는 서버 인덱스이다.
            guard let nowIndex = ClothingIndex.subCategoryList[$0.category]?.mainIndex else { return true }
            return nowIndex == indexPath.section
        }

        closetListTableViewCell.delegate = self
        closetListTableViewCell.configureCell(clothingData: clothingData)

        return closetListTableViewCell
    }
}

extension ClosetListViewController: ClosetListTableViewCellDelegate {
    func numberOfItemsUpdated(numberOfItemsCount _: Int) {}

    func subCollectionViewCellSelected(collectionViewCell: ClosetListCollectionViewCell) {
        guard let cellClothingData = collectionViewCell.clothingData else { return }
        if collectionViewCell.isSelected {
            selectedClothingData.insert(cellClothingData)
        } else {
            selectedClothingData.remove(cellClothingData)
        }
    }
}

extension ClosetListViewController: RequestAPIDelegate {
    func requestAPIDidBegin() {
        // 인디케이터 동작
        isAPIDataRequested = true
    }

    func requestAPIDidFinished() {
        // 인디케이터 종료 및 세그 동작 실행
        isAPIDataRequested = false
        isRefreshControlRunning = false
        if RequestImage.shared.isImageKeyEmpty(), !isImageDataRequested {}
    }

    func requestAPIDidError() {
        // 에러 발생 시 동작 실행
        isAPIDataRequested = false
        isRefreshControlRunning = false
        if RequestImage.shared.isImageKeyEmpty(), !isImageDataRequested {}
    }
}

extension ClosetListViewController: RequestImageDelegate {
    func imageRequestDidBegin() {
        isImageDataRequested = true
    }

    func imageRequestDidFinished(_: UIImage, imageKey _: String) {
        checkImageDataRequest()
    }

    func imageRequestDidError(_: String) {
        checkImageDataRequest()
        DispatchQueue.main.async {
            guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
            tabBarController.presentToastMessage("이미지 로딩 중 에러가 발생했습니다.")
        }
    }
}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
        configureRefreshControl()
        RequestAPI.shared.delegate = self
        RequestImage.shared.delegate = self
        closetListTableView.dataSource = self
        closetListTableView.delegate = self
        closetListTableView.allowsSelection = false
    }
}
