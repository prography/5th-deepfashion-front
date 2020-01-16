//
//  ClosetListTableHeaderView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/06.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListTableHeaderView: UIView {
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "헤더뷰 타이틀"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.mainFont(displaySize: 14)
        titleLabel.textColor = .white
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        addSubviews()
        configureConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    func configureTitleLabel(_ text: String) {
        titleLabel.text = text
    }

    func addSubviews() {
        addSubview(titleLabel)
    }

    func configureConstraint() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}
