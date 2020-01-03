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
        RequestAPI.shared.delegate = self
        RequestImage.shared.delegate = self
        configureBasicTitle(ViewData.Title.MainTabBarView.closetList)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        viewMode = .view
        requestClothingNetworkTask()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        inactivateEditBarButtonItem()
        inactivateDeleteBarButtonItem()

        // TEST
        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
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

    private func requestClothingNetworkTask() {
        if UserCommonData.shared.isNeedToUpdateClothing == false { return }
        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in
            if networkError == nil {
                guard let clothingDataList = clothingDataList else { return }
                UserCommonData.shared.configureClothingData(clothingDataList)
                CodiListGenerator.shared.getNowCodiDataSet(clothingDataList)

                DispatchQueue.main.async {
//                    guard let tabBarController = self.tabBarController as? MainTabBarController else { return }
//                    tabBarController.reloadRecommendCollectionView(clothingDataList)
                    self.closetListTableView.reloadData()
                    UserCommonData.shared.setIsNeedToUpdateClothingFalse()
                }
            } else {
                DispatchQueue.main.async {
                    guard let tabBarController = self.tabBarController else { return }
                    ToastView.shared.presentShortMessage(tabBarController.view, message: "옷 정보를 불러오는데 실패했습니다.")
                }
            }
        }
    }

    private func checkImageDataRequest() {
        isImageDataRequested = RequestImage.shared.isImageKeyEmpty() ? false : true
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
                    for selectedData in self.selectedClothingData {
                        self.deletingClotingRequestCount += 1
                        RequestAPI.shared.deleteAPIData(APIMode: .deleteClothing, targetId: selectedData.id) { networkError in
                            DispatchQueue.main.async {
                                self.deletingClotingRequestCount -= 1
                                if networkError == nil {
                                    if self.deletingClotingRequestCount == 0 {
                                        self.closetListTableView.reloadData()
                                        ToastView.shared.presentShortMessage(tabBarController.view, message: "옷 삭제에 성공하였습니다. ")
                                        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
                                        self.requestClothingNetworkTask()
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
        return ViewData.Row.Height.closetList
        //        guard let tableViewCell = tableView.cellForRow(at: indexPath) as? ClosetListTableViewCell else { return ViewData.Row.Height.closetList }
        //
        //        print("TLqkf : \(ViewData.Row.Height.closetList * CGFloat(max(1,((tableViewCell.closetListDataCount - 1) / 3 + 1))))")
        //        return ViewData.Row.Height.closetList * CGFloat(max(1,((tableViewCell.closetListDataCount - 1) / 3 + 1)))
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

        let clothingData = UserCommonData.shared.clothingList.filter {
            // 받은 인덱스는 서버 인덱스이다.
            guard let nowIndex = ClothingCategoryIndex.subCategoryList[$0.category]?.mainIndex else { return true }
            return nowIndex == indexPath.section
        }

        closetListTableViewCell.configureCell(clothingData: clothingData)

        closetListTableViewCell.delegate = self
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
        if RequestImage.shared.isImageKeyEmpty(), !isImageDataRequested {}
    }

    func requestAPIDidError() {
        // 에러 발생 시 동작 실행
        isAPIDataRequested = false
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

    func imageRequestDidError(_ errorDescription: String) {
        checkImageDataRequest()
        DispatchQueue.main.async {
            guard let tabBarController = self.tabBarController else { return }
            ToastView.shared.presentShortMessage(tabBarController.view, message: "이미지 로딩 중 에러가 발생했습니다. \(errorDescription)")
        }
    }
}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        closetListTableView.dataSource = self
        closetListTableView.delegate = self
        closetListTableView.allowsSelection = false
    }
}
