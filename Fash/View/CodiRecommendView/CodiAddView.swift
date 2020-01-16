//
//  CodiAddView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/06.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiAddView: UIView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageViewList: [UIImageView]!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureByNib()

        nameTextField.layer.cornerRadius = 5
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureByNib()
    }

    private func configureByNib() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: UIIdentifier.NibName.codiAddView, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func configureImage(_ imageList: [UIImage]) {
        
        resetCodiViewName()
        for i in imageViewList.indices {
            imageViewList[i].layer.cornerRadius = 5
            if imageList.count - 1 < i { break }
            DispatchQueue.main.async {
                self.imageViewList[i].image = imageList[i]
            }
        }
    }

    private func resetCodiViewName() {
        nameTextField.text = ""
    }

    @IBAction func addButtonPressed(_: UIButton) {}

    @IBAction func cancelButtonPressed(_: UIButton) {}
}
