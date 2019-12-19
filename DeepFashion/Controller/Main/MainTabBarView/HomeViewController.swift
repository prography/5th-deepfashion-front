//
//  HomeViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

@IBDesignable
class HomeViewController: UIViewController {
    // MARK: - Life Cycle

    var codiIdCount = 0

    @IBOutlet var clothingInfoView: [MainClothingInfoView]!
    @IBOutlet var codiListSaveButton: UIButton!

    private let clothingPartTitle = [" Top", " Outer", " Bottom", " Shoes"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureClothingInfoViewTitle()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }

    private func configureClothingInfoViewTitle() {
        for i in clothingPartTitle.indices {
            clothingInfoView[i].titleLabel.text = clothingPartTitle[i]
        }
    }

    private func configureCodiListSaveButton() {
        codiListSaveButton.isEnabled = true
    }

    @IBAction func saveButtonPressed(_: UIButton) {
        var codiDataSet = [CodiData]()
        for i in clothingInfoView.indices {
            let codiData = CodiData(codiImage: clothingInfoView[i].clothingImageView.image, codiId: codiIdCount)
            codiDataSet.append(codiData)
            if codiDataSet.count == 4 { break }
        }
        CommonUserData.shared.addCodiData(codiDataSet)
        print("codiDataSet Added!!")
        codiIdCount += 1
    }
}

extension HomeViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.homeView)
        configureCodiListSaveButton()
    }
}
