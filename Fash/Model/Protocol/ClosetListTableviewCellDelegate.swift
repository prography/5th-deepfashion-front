//
//  ClosetListTableviewCellDelegate.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/23.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

protocol ClosetListTableViewCellDelegate: class {
    func subCollectionViewCellSelected(collectionViewCell: ClosetListCollectionViewCell)
    func numberOfItemsUpdated(numberOfItemsCount: Int)
}
