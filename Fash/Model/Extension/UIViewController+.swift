//
//  UIPickerViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Photos
import UIKit

extension UIViewController {
    typealias completionHandler = () -> Void

    func endIgnoringInteractionEvents() {
        DispatchQueue.main.async {
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }

    func beginIgnoringInteractionEvents() {
        DispatchQueue.main.async {
            if !UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }

    func openPhotoAlbum(_ imagePickerController: UIImagePickerController) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func openCamera(_ imagePickerController: UIImagePickerController) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }

    func closePhotoAlbum(_ imagePickerController: UIImagePickerController, completion: @escaping () -> Void) {
        imagePickerController.dismiss(animated: true) {
            completion()
        }
    }

    func presentAuthRequestAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let getAuthAction = UIAlertAction(title: "네", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let denyAuthAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alertController.addAction(getAuthAction)
        alertController.addAction(denyAuthAction)
        present(alertController, animated: true, completion: nil)
    }

    func presentBasicOneButtonAlertController(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let getAuthAction = UIAlertAction(title: "네", style: .default) { _ in
            completion?()
        }
        alertController.addAction(getAuthAction)
        present(alertController, animated: true, completion: nil)
    }

    func presentBasicTwoButtonAlertController(title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let getAuthAction = UIAlertAction(title: "네", style: .default) { _ in
            completion(true)
        }

        let denyAuthAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            completion(false)
        }
        alertController.addAction(getAuthAction)
        alertController.addAction(denyAuthAction)

        present(alertController, animated: true, completion: nil)
    }

    func setCustomNavigationBarBackButton() {
        let backButton: UIButton = {
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
//            backButton.setTitleColor(UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1), for: .normal)
//            backButton.tintColor = UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
//            backButton.backgroundColor = UIColor(displayP3Red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
            backButton.setTitle("Back", for: .normal)
            backButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
            backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
            return backButton
        }()

        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    func configureBasicTitle(_ title: String) {
        tabBarController?.title = title
    }

    func configureEmptyTitle() {
        title = ""
        navigationController?.title = ""
    }

    @objc func backButtonPressed(_: UIButton) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}
