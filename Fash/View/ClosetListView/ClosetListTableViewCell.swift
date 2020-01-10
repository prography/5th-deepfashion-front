//
//  ClosetListTableViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListTableViewCell: UITableViewCell {
    // MARK: UIs

    @IBOutlet var collectionView: UICollectionView!
    weak var delegate: ClosetListTableViewCellDelegate?

    // MARK: Properties

    private var closetListData: [ClothingAPIData] = []

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: Methods

    func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = UIScreen.main.bounds.width / 4 - 10
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView.collectionViewLayout = flowLayout
    }

    func configureCell(clothingData: [ClothingAPIData]) {
        closetListData = clothingData
        collectionView.delegate = self
        collectionView.dataSource = self
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ClosetListTableViewCell: UICollectionViewDelegate {}

extension ClosetListTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return closetListData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let closetListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.closetList, for: indexPath) as? ClosetListCollectionViewCell else { return UICollectionViewCell() }
        closetListCollectionViewCell.delegate = self
        closetListCollectionViewCell.configureCell(clothingData: closetListData[indexPath.item])
        return closetListCollectionViewCell
    }
}

extension ClosetListTableViewCell: UICollectionViewCellDelegate {
    func collectinoViewCellItemSelected(_ collectionViewCell: UICollectionViewCell) {
        guard let collectionViewCell = collectionViewCell as? ClosetListCollectionViewCell else { return }
        delegate?.subCollectionViewCellSelected(collectionViewCell: collectionViewCell)
    }
}
