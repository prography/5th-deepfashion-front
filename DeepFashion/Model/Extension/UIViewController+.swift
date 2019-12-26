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

    func openPhotoAlbum(_ imagePickerController: UIImagePickerController) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func openCamera(_ imagePickerController: UIImagePickerController) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
            return true
        } else {
            return false
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
        let denyAuthAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
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

        let denyAuthAction = UIAlertAction(title: "아니오", style: .default) { _ in
            completion(false)
        }
        alertController.addAction(getAuthAction)
        alertController.addAction(denyAuthAction)

        present(alertController, animated: true, completion: nil)
    }

    func configureBasicTitle(_ title: String) {
        tabBarController?.title = title
        navigationController?.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.subFont(displaySize: 18)]
    }
}
