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

    private var closetListData: [ClothingAPIData] = [] {
        didSet {
            closetListDataCount = closetListData.count
        }
    }

    private(set) var closetListDataCount = 0

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
        closetListData = clothingData.sorted()
        collectionView.delegate = self
        collectionView.dataSource = self
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func removeSelectedCollectionViewCell(_ completion: @escaping (Bool) -> Void) {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }

        if !selectedIndexPaths.isEmpty {
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: selectedIndexPaths)
                closetListDataCount -= selectedIndexPaths.count
            }) { isSucceed in
                if isSucceed {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}

extension ClosetListTableViewCell: UICollectionViewDelegate {}

extension ClosetListTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        delegate?.numberOfItemsUpdated(numberOfItemsCount: closetListDataCount)
        return closetListDataCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let closetListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.closetList, for: indexPath) as? ClosetListCollectionViewCell else { return UICollectionViewCell() }
        closetListCollectionViewCell.configureCell(clothingData: closetListData[indexPath.item])
        closetListCollectionViewCell.delegate = self
        return closetListCollectionViewCell
    }
}

extension ClosetListTableViewCell: UICollectionViewCellDelegate {
    func collectinoViewCellItemSelected(_ collectionViewCell: UICollectionViewCell) {
        guard let collectionViewCell = collectionViewCell as? ClosetListCollectionViewCell else { return }
        delegate?.subCollectionViewCellSelected(collectionViewCell: collectionViewCell)
    }
}
