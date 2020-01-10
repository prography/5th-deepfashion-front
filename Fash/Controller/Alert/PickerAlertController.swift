//
//  PickerViewAlertController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/02.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class PickerAlertController: UIAlertController {
    // MARK: UIs

    let pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        return pickerView
    }()

    private(set) var defaultPickerViewRowIndex = 0

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        makeAlertAction()
    }

    override func viewDidDisappear(_: Bool) {
        super.viewDidDisappear(true)
        configureDefaultPickerViewIndex()
    }

    // MARK: Method

    // MARK: - Setting

    func configureDefaultPickerViewIndex() {
        pickerView.selectRow(defaultPickerViewRowIndex, inComponent: 0, animated: false)
    }

    private func makeAlertAction() {
        let alertAction = UIAlertAction(title: "선택", style: .default, handler: nil)
        addAction(alertAction)
    }

    private func makeSubviews() {
        view.addSubview(pickerView)
    }

    private func makeConstraints() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
        ])
    }
}
