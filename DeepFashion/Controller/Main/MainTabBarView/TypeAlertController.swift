//
//  FashionTypeAlertController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/28.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class TypeAlertController: UIAlertController {
    // MARK: UIs

    let fashionTypePickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        return pickerView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        makeAlertAction()
    }

    // MARK: Method

    // MARK: - Configuration

    private func makeAlertAction() {
        let pickerAction = UIAlertAction(title: "선택", style: .default, handler: nil)
        addAction(pickerAction)
    }

    private func makeSubviews() {
        view.addSubview(fashionTypePickerView)
    }

    private func makeConstraints() {
        fashionTypePickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fashionTypePickerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            fashionTypePickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            fashionTypePickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            fashionTypePickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
        ])
    }
}
