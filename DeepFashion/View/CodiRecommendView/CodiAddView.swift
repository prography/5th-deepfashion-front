//
//  CodiAddView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/06.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiAddView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageViewList: [UIImageView]!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureByNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureByNib()
    }

    private func configureByNib() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: UIIdentifier.NibName.codiAddView, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    @IBAction func addButtonPressed(_: UIButton) {}

    @IBAction func cancelButtonPressed(_: UIButton) {}
}
