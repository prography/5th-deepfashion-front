//
//  ClosetListTableHeaderView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListTableHeaderView: UIView {
    @IBOutlet var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
