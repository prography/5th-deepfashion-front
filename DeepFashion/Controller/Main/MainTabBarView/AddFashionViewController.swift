//
//  AddFashionViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionViewController: UIViewController {
    @IBOutlet var fashionImageView: UIImageView!
    var selectedFashionImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        fashionImageView.image = selectedFashionImage
    }

    @IBAction func addFashionButton(_: UIButton) {
        print("Add the Fashion!!")
    }

    @IBAction func cancelButton(_: UIButton) {
        print("Cancel Adding the Fashion!!")
//        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
