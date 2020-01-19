//
//  LogoAnimationView.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/19.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import SwiftGifOrigin
import UIKit

class LogoAnimationView: UIView {
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
//        logoImageView.image = UIImage.gif(name: AssetIdentifier.Image.fashSplash)
        logoImageView.loadGif(asset: AssetIdentifier.Image.fashSplash)
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addSubviews() {
        addSubview(logoImageView)
    }

    private func makeConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            logoImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
        ])
    }
}
