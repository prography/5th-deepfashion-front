//
//  AddPhotoViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import Photos
import UIKit

class PhotoAddViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var selectedPhotoImageView: UIImageView!

    private let photoSelectAlertController: UIAlertController = {
        let photoSelectAlertController = UIAlertController(title: "사진 추가방법 선택", message: "사진 추가방법을 선택하세요.", preferredStyle: .actionSheet)
        return photoSelectAlertController
    }()

    private let photoPickerViewController: UIImagePickerController = {
        let photoPickerViewController = UIImagePickerController()
        photoPickerViewController.allowsEditing = true
        return photoPickerViewController
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        photoPickerViewController.delegate = self
        configurePhotoSelectAlertController()
    }

    func configurePhotoSelectAlertController() {
        let takePictureAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { _ in
            print("사진 찍기 클릭")
            self.openCamera(self.photoPickerViewController)
            // 초기 실행 시, 사진 촬영 권한 요청, 흭득 시 사용 가능
        }

        let getAlbumAlertAction = UIAlertAction(title: "앨범 사진 가져오기", style: .default, handler: { _ in
            // * 추후 코드 정리 필요
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

            switch photoAuthorizationStatus {
            case .notDetermined:
                print("notDetermined, 아직 응답하지 않음")
                // 처음 응답이 없었을때 권한요청을 한다. 권한허용을 했다면, 앨범을 불러온다. 거절되면 빈 셀을 띄운다.
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        print("사용자 측 권한 허용 선택")
                        // 이때는 앨범 리스트를 연다.
                        self.openPhotoAlbum(self.photoPickerViewController)
                        print("Present the Album List")
                    default:
                        print("사용자 불허")
                    }
                }
            case .restricted, .denied:
                self.presentPhotoAuthRequestAlertController()
            case .authorized:
                print("authorized, 접근 승인")
                // 이때는 앨범을 열어준다.
                self.openPhotoAlbum(self.photoPickerViewController)
                print("Present the Album List")
            @unknown default:
                fatalError()
            }
        })
        photoSelectAlertController.addAction(takePictureAlertAction)
        photoSelectAlertController.addAction(getAlbumAlertAction)
    }

    func presentPhotoSelectAlertController() {
        present(photoSelectAlertController, animated: true, completion: nil)
    }

    func presentPhotoAuthRequestAlertController() {
        let alertController = UIAlertController(title: "사집첩 권한 필요", message: "사진첩 사용을 위해 권한허용 설정을 해주세요.", preferredStyle: .alert)
        let getAuthAction = UIAlertAction(title: "네", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let denyAuthAction = UIAlertAction(title: "싫습니다", style: .cancel, handler: nil)
        alertController.addAction(getAuthAction)
        alertController.addAction(denyAuthAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Methods

    func checkAlbumAuthority(alertAction _: UIAlertAction) {}
}

extension PhotoAddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        selectedPhotoImageView.image = selectedImage
        closePhotoAlbum(photoPickerViewController)
    }
}

extension PhotoAddViewController: UINavigationControllerDelegate {}
