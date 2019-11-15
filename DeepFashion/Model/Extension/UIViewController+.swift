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

    func closePhotoAlbum(_ imagePickerController: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
