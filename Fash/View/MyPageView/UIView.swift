//
//  ClosetListTableHeaderView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MyPageTableHeaderView: UIView {
    let backButton: UIButton = {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        backButton.setTitleColor(UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1), for: .normal)
        backButton.tintColor = UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        return backButton
    }()

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.subFont(displaySize: 18)
        titleLabel.textColor = UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews()
        configureConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configureTitleLabel(_ text: String) {
        titleLabel.text = text
    }

    func addSubviews() {
        addSubview(titleLabel)
        addSubview(backButton)
    }

    func configureConstraint() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
    }
}
