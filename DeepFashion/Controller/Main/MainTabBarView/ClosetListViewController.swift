//
//  ClosetListViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListViewController: UIViewController {
    @IBOutlet var closetListCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()

        DispatchQueue.main.async {
            self.closetListCollectionView.reloadData()
        }
    }
}

// 셀의 크기, 행 별 갯수를 지정하기 위한 UICollectionViewDelegateFlowLayout 프로토콜 채택
extension ClosetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        guard let flowLayout: UICollectionViewFlowLayout = closetListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }

        // 행에 들어갈 셀의 갯수는 2개
        let numberOfCellsInRow: CGFloat = 3

        // 현재 뷰의 사이즈를 가져온다.
        let viewSize: CGSize = view.frame.size

        // 섹션 여백에 대한 프로퍼티
        let sectionInset: UIEdgeInsets = flowLayout.sectionInset

        // 셀 사이의 빈 최소 여백(minimumLineSpacing) 크기를 계산한다.
        let interItemSpace: CGFloat = flowLayout.minimumLineSpacing * (numberOfCellsInRow - 1)

        // 행의 셀갯수를 2개가 들어가도록 & 좌우, inset 셀사이 여백값을 감안하여 셀의 가로길이를 계산한다.
        let itemLength: CGFloat = (viewSize.width - interItemSpace - sectionInset.left - sectionInset.right) / numberOfCellsInRow

        // 사진과 내용이 들어간 셀은 세로방향으로 길쭉한 직사각형이 되도록 설정한다.
        let itemSize = CGSize(width: itemLength, height: itemLength)

        // 설정한 item셀 사이즈 크기를 반환하여 레이아웃 상에 적용한다.
        return itemSize
    }
}

extension ClosetListViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return CommonUserData.shared.userImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.closetList, for: indexPath) as? ClosetListCollectionViewCell else { return UICollectionViewCell() }

        collectionViewCell.fashionImageView.image = CommonUserData.shared.userImage[indexPath.item]
        return collectionViewCell
    }
}

extension ClosetListViewController: UICollectionViewDelegate {}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.closetListView)
        closetListCollectionView.delegate = self
        closetListCollectionView.dataSource = self
    }
}
