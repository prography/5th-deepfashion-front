//
//  MainClothingInfoView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MainClothingInfoView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var clothingImageView: UIImageView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureByNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureByNib()
    }

    private func configureByNib() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: UIIdentifier.NibName.mainClothingInfoView, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
