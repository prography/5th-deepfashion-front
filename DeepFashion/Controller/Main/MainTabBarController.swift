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

    private var tabBarHeight: CGFloat = 60
    private(set) var selectedPreviousIndex = 0

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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
    }

    private func configureEditBarButtonItem() {}

    override func tabBar(_: UITabBar, didSelect _: UITabBarItem) {
        guard let previousViewController = self.viewControllers?[selectedPreviousIndex] as? UINavigationController else { return }
        previousViewController.popToRootViewController(animated: false)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect _: UIViewController) {
        selectedPreviousIndex = tabBarController.selectedIndex
        tabBarController.removeBackButton()
    }
}
