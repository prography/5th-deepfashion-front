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
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        configureFashionTypeSegmentedControl()
    }

    /// fashionNameTextField 값이 들어갔는지 확인하는 메서드
    func checkNameTextFieldContents() -> Bool {
        guard let nameText = nameTextField.text else { return false }
        return nameText.trimmingCharacters(in: .whitespaces).isEmpty ? false : true
    }

    private func configureFashionTypeSegmentedControl() {
        // 초기 선택 인덱스를 설정
        typeSegmentedControl.selectedSegmentIndex = 0
    }
}
