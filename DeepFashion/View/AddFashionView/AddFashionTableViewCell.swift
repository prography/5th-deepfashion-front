//
//  AddFashionTableViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/20.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionTableViewCell: UITableViewCell {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var styleButton: UIButton!
    @IBOutlet var typeSegmentedControl: UISegmentedControl!
    @IBOutlet var weatherSegmentedControl: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
