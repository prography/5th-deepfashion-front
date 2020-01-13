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

    private enum TabBarIndex {
        case codiRecommend
        case closetList
        case clothingAdd
        case codiList
        case myPage

        var index: Int {
            switch self {
            case .codiRecommend:
                return 0
            case .closetList:
                return 1
            case .clothingAdd:
                return 2
            case .codiList:
                return 3
            case .myPage:
                return 4
            }
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowOpacity = 0.3
    }

    private func configureTabBarController() {
        navigationItem.setHidesBackButton(true, animated: false)
        delegate = self
        configureEditBarButtonItem()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBarHeight = view.safeAreaInsets.bottom == 0 ? 60 : 100
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight
    }

    private func configureEditBarButtonItem() {}

    func presentToastMessage(_ message: String) {
        guard let navigationController = self.navigationController else { return }
        DispatchQueue.main.async {
            ToastView.shared.presentShortMessage(navigationController.view, message: message)
        }
    }

    func reloadRecommendCollectionView(_: ClothingAPIDataList) {
        guard let recommendViewController = self.viewControllers?.first as? CodiRecommendViewController else { return }
        DispatchQueue.main.async {
            recommendViewController.requestClothingAPIDataList()
        }
    }

    func reloadClosetListTableView() {
        guard let closetListViewController = self.viewControllers?[TabBarIndex.closetList.index] as? ClosetListViewController else { return }
        DispatchQueue.main.async {
            closetListViewController.closetListTableView.reloadData()
        }
    }

    override func tabBar(_: UITabBar, didSelect _: UITabBarItem) {
        guard let previousViewController = self.viewControllers?[selectedPreviousIndex] as? UINavigationController else { return }
        previousViewController.popToRootViewController(animated: false)

        if selectedPreviousIndex == TabBarIndex.myPage.index {
            tabBarController?.navigationController?.popViewController(animated: false)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect _: UIViewController) {
        selectedPreviousIndex = tabBarController.selectedIndex
        tabBarController.removeBackButton()

        if tabBarController.selectedIndex == TabBarIndex.clothingAdd.index {
            guard let nowViewController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? ClothingAddViewController else { return }
            nowViewController.presentPhotoSelectAlertController()
        }
    }
}
