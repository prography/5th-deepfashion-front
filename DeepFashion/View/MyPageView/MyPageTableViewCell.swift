//
//  MyPageTableViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/09.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.textColor = ColorList.brownishGray
        backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(title: String) {
        titleLabel.text = title
    }
}
