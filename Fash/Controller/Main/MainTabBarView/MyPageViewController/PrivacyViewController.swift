//
//  PravacyViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
    @IBOutlet var privacyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
//        configureBasicTitle(ViewData.Title.MainTabBarView.privacy)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: Methods

    private func presentDeleteUserViewController() {
        performSegue(withIdentifier: UIIdentifier.Segue.goToDeleteUser, sender: nil)
    }

    @objc func backButtonPressed(_: UIButton) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}

extension PrivacyViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return ViewData.Section.Row.Height.privacy
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return ViewData.Section.Row.Height.privacy
    }

    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let privacyRow = ViewData.Section.Row.Privacy(rawValue: indexPath.row),
            let tabBarController = self.tabBarController as? MainTabBarController else {
            return nil
        }

        switch privacyRow {
        case .password, .style:
            tabBarController.presentToastMessage("해당 기능은 추후 업데이트 예정입니다.")
        case .deleteUser:
            presentDeleteUserViewController()
        }

        return nil
    }
}

extension PrivacyViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return ViewData.Section.Row.privacyTableView.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let privacyTableCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.privacy, for: indexPath) as? PrivacyTableViewCell else { return UITableViewCell() }

        privacyTableCell.configureCell(ViewData.Section.Row.privacyTableView[indexPath.row])
        return privacyTableCell
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = MyPageTableHeaderView()
        headerView.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        headerView.configureTitleLabel(ViewData.Title.MainTabBarView.privacy)
        return headerView
    }
}

extension PrivacyViewController: UINavigationControllerDelegate {}

extension PrivacyViewController: UIViewControllerSetting {
    func configureViewController() {
        privacyTableView.delegate = self
        privacyTableView.dataSource = self
    }
}
