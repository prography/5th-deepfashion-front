//
//  MyPageViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/18.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {
    // MARK: - Life Cycle

    @IBOutlet var myPageTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }
}

extension MyPageViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.myPageView)
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MyPageTableHeaderView()
        headerView.configureTitleLabel("Now Section is \(section)!!")
        return headerView
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

extension MyPageViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myPageCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.myPage, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }

        return myPageCell
    }
}
