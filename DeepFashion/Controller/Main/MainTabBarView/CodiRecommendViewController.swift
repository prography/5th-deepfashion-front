//
//  HomeViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class CodiRecommendViewController: UIViewController {
    // MARK: UIs

    @IBOutlet var clothingInfoView: [MainClothingInfoView]!
    @IBOutlet var codiListSaveButton: UIButton!

    // MARK: Properties

    private let clothingPartTitle = [" Top", " Outer", " Bottom", " Shoes"]
    private var codiIdCount = 0

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureClothingInfoViewTitle()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }

    // MARK: Methods

    private func configureClothingInfoViewTitle() {
        for i in clothingPartTitle.indices {
            clothingInfoView[i].titleLabel.text = clothingPartTitle[i]
        }
    }

    private func configureCodiListSaveButton() {
        codiListSaveButton.isEnabled = true
    }

    // MARK: - IBAction

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

extension CodiRecommendViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.homeView)
        configureCodiListSaveButton()
    }
}
