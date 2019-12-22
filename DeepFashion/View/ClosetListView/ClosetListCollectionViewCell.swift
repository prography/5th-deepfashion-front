//
//  ClosetListCollectionViewCell.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIs
    
    @IBOutlet var fashionImageView: UIImageView!
    private var selectEffectView: UIView = {
        let selectEffectView = UIView()
        selectEffectView.backgroundColor = .white
        selectEffectView.layer.borderWidth = 1
        selectEffectView.layer.borderColor = UIColor.black.cgColor
        selectEffectView.alpha = 0.6
        selectEffectView.isHidden = true
        return selectEffectView
    }()
    
    // MARK: Properties
    
    override var isSelected: Bool {
        didSet {
            selectEffectView.isHidden = !isSelected
        }
    }
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
        addSubviews()
        makeConstraints()
    }
    
    // MARK: Methods
    
    func configureCell(image: UIImage) {
        fashionImageView.image = image
    }
    
    func addSubviews() {
        addSubview(selectEffectView)
    }
    
    func makeConstraints() {
        selectEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectEffectView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            selectEffectView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            selectEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            selectEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
