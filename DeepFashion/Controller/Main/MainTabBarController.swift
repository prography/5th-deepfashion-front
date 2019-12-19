//
//  MainTabBarController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: - Properties

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }

    private func configureTabBarController() {
        navigationItem.setHidesBackButton(true, animated: false)
        delegate = self
        configureEditBarButtonItem()
    }

    private func configureEditBarButtonItem() {}
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect viewController: UIViewController) {
        guard let photoAddViewController = viewController as? PhotoAddViewController else { return }
        photoAddViewController.presentPhotoSelectAlertController()
    }
}
