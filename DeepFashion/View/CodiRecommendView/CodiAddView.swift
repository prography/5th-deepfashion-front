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
    @IBOutlet var nameTextField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureByNib()
        titleLabel.font = UIFont.subFont(displaySize: 18)
        addButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        cancelButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        nameTextField.layer.borderColor = ViewData.Color.border
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
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

    func configureImage(_ imageList: [UIImage]) {
        for i in imageViewList.indices {
            imageViewList[i].layer.cornerRadius = 10
            imageViewList[i].layer.borderWidth = 3
            imageViewList[i].layer.borderColor = ViewData.Color.border
            if imageList.count - 1 < i { break }
            DispatchQueue.main.async {
                self.imageViewList[i].image = imageList[i]
            }
        }
    }

    @IBAction func addButtonPressed(_: UIButton) {}

    @IBAction func cancelButtonPressed(_: UIButton) {}
}
