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

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()

        DispatchQueue.main.async {
            self.closetListTableView.reloadData()
        }
    }
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
        print(headerViewTitleText)
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
        let clothingData = CommonUserData.shared.userClothingList.filter { $0.fashionType == indexPath.section }
        print("Now Index Section : \(indexPath.section)")
        print("Now Section Data : \(clothingData)")
        closetListTableViewCell.configureCell(clothingData: clothingData)
        return closetListTableViewCell
    }
}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.closetListView)
        closetListTableView.delegate = self
        closetListTableView.dataSource = self
    }
}

// 셀의 크기, 행 별 갯수를 지정하기 위한 UICollectionViewDelegateFlowLayout 프로토콜 채택
// extension ClosetListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
//        guard let flowLayout: UICollectionViewFlowLayout = closetListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
//
//        // 행에 들어갈 셀의 갯수는 2개
//        let numberOfCellsInRow: CGFloat = 3
//
//        // 현재 뷰의 사이즈를 가져온다.
//        let viewSize: CGSize = view.frame.size
//
//        // 섹션 여백에 대한 프로퍼티
//        let sectionInset: UIEdgeInsets = flowLayout.sectionInset
//
//        // 셀 사이의 빈 최소 여백(minimumLineSpacing) 크기를 계산한다.
//        let interItemSpace: CGFloat = flowLayout.minimumLineSpacing * (numberOfCellsInRow - 1)
//
//        // 행의 셀갯수를 2개가 들어가도록 & 좌우, inset 셀사이 여백값을 감안하여 셀의 가로길이를 계산한다.
//        let itemLength: CGFloat = (viewSize.width - interItemSpace - sectionInset.left - sectionInset.right) / numberOfCellsInRow
//
//        // 사진과 내용이 들어간 셀은 세로방향으로 길쭉한 직사각형이 되도록 설정한다.
//        let itemSize = CGSize(width: itemLength, height: itemLength)
//
//        // 설정한 item셀 사이즈 크기를 반환하여 레이아웃 상에 적용한다.
//        return itemSize
//    }
// }
