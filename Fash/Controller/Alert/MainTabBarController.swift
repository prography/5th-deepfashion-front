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
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
    }

    private func configureTabBarController() {
        delegate = self
        view.backgroundColor = .clear
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.backgroundColor = UIColor(white: 1, alpha: 0.3).cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowRadius = 3
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
    
    func updateRecommendCodiList() {
        guard let recommendViewController = self.viewControllers?.first as? CodiRecommendViewController else { return }
        CodiListGenerator.shared.getNowCodiDataSet()
        recommendViewController.updateRecommendedCodiList()
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

//        if selectedPreviousIndex == TabBarIndex.myPage.index {
//            tabBarController?.navigationController?.popViewController(animated: false)
//            navigationController?.title = ""
//        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect _: UIViewController) {
        selectedPreviousIndex = tabBarController.selectedIndex

        if tabBarController.selectedIndex == TabBarIndex.codiRecommend.index
            || tabBarController.selectedIndex == TabBarIndex.myPage.index {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }

        if tabBarController.selectedIndex == TabBarIndex.clothingAdd.index {
            guard let nowViewController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? ClothingAddViewController else { return }
            nowViewController.presentPhotoSelectAlertController()
        }
    }
}
