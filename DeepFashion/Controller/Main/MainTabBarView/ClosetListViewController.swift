//
//  ClosetListViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class ClosetListViewController: UIViewController {
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var closetListTableView: UITableView!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()

        DispatchQueue.main.async {
            self.closetListTableView.reloadData()
        }
    }
}

extension ClosetListViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 30
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fashionType = FashionType(rawValue: section)
        guard let headerViewTitleText = fashionType?.title else { return UIView() }

        let closetListTableHeaderView = ClosetListTableHeaderView()
        closetListTableHeaderView.configureTitleLabel(headerViewTitleText)
        return closetListTableHeaderView
    }
}

extension ClosetListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let closetListTableViewCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.closetList, for: indexPath) as? ClosetListTableViewCell else { return UITableViewCell() }
        let clothingData = CommonUserData.shared.userClothingList.filter { $0.fashionType == indexPath.section }
        closetListTableViewCell.configureCell(clothingData: clothingData)
        return closetListTableViewCell
    }
}

extension ClosetListViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.closetListView)
        closetListTableView.delegate = self
        closetListTableView.dataSource = self
    }
}
