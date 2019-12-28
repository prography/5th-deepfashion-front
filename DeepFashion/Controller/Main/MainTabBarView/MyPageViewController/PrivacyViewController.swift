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

    private var subTitleList = ["비밀번호변경", "회원탈퇴"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.hidesBackButton = false
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureBasicTitle(ViewData.Title.MainTabBarView.privacy)
        configureBackButton()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: Methods

    private func configureBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        backButton.setTitleColor(.white, for: .normal)
        backButton.tintColor = .white
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        tabBarController?.navigationItem.leftBarButtonItem = backBarButton
    }

    private func presentDeleteUserViewController() {
        performSegue(withIdentifier: UIIdentifier.Segue.goToDeleteUser, sender: nil)
    }

    @objc func backButtonPressed(_: UIButton) {
        guard let navigationController = self.navigationController else { return }
        tabBarController?.removeBackButton()
        navigationController.popViewController(animated: true)
    }
}

extension PrivacyViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = MyPageTableHeaderView()
        headerView.configureTitleLabel("개인정보/보안")
        return headerView
    }

    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let privacyRow = ViewData.Section.Row.Privacy(rawValue: indexPath.row) else {
            return nil
        }

        switch privacyRow {
        case .password:
            break
        case .deleteUser:
            presentDeleteUserViewController()
        }

        return nil
    }
}

extension PrivacyViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return subTitleList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let privacyTableCell = tableView.dequeueReusableCell(withIdentifier: UIIdentifier.Cell.TableView.privacy, for: indexPath) as? PrivacyTableViewCell else { return UITableViewCell() }

        privacyTableCell.configureCell(subTitleList[indexPath.row])
        return privacyTableCell
    }
}

extension PrivacyViewController: UINavigationControllerDelegate {}

extension PrivacyViewController: UIViewControllerSetting {
    func configureViewController() {
        privacyTableView.delegate = self
        privacyTableView.dataSource = self
    }
}
