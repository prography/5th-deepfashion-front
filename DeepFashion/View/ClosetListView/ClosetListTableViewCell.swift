//
//  ClosetListTableViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListTableViewCell: UITableViewCell {
    @IBOutlet var closetListCollectionView: UICollectionView!
    private var closetListData: [UserClothingData] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        closetListCollectionView.delegate = self
        closetListCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(clothingData: [UserClothingData]) {
        closetListData = clothingData
        DispatchQueue.main.async {
            self.closetListCollectionView.reloadData()
        }
    }
}

extension ClosetListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ClosetListTableViewCell: UICollectionViewDelegate {}

extension ClosetListTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return closetListData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let closetListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.CollectionView.closetList, for: indexPath) as? ClosetListCollectionViewCell else { return UICollectionViewCell() }
        closetListCollectionViewCell.configureCell(image: closetListData[indexPath.item].image)
        return closetListCollectionViewCell
    }
}
