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
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureBasicTitle(ViewData.Title.MainTabBarView.myPage)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewDidDisappear(true)
    }

    private func presentPrivacyViewController() {
        performSegue(withIdentifier: UIIdentifier.Segue.goToPrivacy, sender: nil)
    }

    private func presentLogoutAlertController() {
        presentBasicTwoButtonAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?") { isApproved in
            if isApproved {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: UIIdentifier.Segue.unwindToLogin, sender: nil)
                }
            }
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = MyPageTableHeaderView()
        headerView.configureTitleLabel("마이 페이지")
        return headerView
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

extension MyPageViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return ViewData.Section.Count.myPageTableView
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return ViewData.Section.Row.myPageTableView.count
    }

    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let myPageRow = ViewData.Section.Row.MyPage(rawValue: indexPath.row) else {
            return nil
        }

        switch myPageRow {
        case .notice:
            break
        case .privacy:
            presentPrivacyViewController()
        case .modifyStyle:
            break
        case .rule:
            break
        case .logout:
            presentLogoutAlertController()
        }

        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myPageCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.myPage, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }

        myPageCell.configureCell(title: ViewData.Section.Row.myPageTableView[indexPath.row])
        return myPageCell
    }
}

extension MyPageViewController: UIViewControllerSetting {
    func configureViewController() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        myPageTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        myPageTableView.separatorColor = ColorList.newBrown
        myPageTableView.tableFooterView?.isHidden = true
    }
}
