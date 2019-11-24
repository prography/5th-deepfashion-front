//
//  ClosetListCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fashionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }
}
