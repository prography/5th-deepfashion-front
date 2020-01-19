//
//  LogoAnimationView.swift
//  Fash
//
//  Created by MinKyeongTae on 2020/01/19.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class LogoAnimationView: UIView {
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage.getGifImageWithName(AssetIdentifier.Image.fashSplash)
        return logoImageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(logoImageView)
    }
    
    private func makeConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            logoImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 120)
        ])
    }
    
    
}
