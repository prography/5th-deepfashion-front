//
//  AddPhotoViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import AVFoundation
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
            let cameraType = AVMediaType.video
            let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: cameraType)
            switch cameraAuthStatus {
            case .authorized:
                if self.openCamera(self.photoPickerViewController) {
                    // succeed
                } else {
                    self.presentCameraAuthRequestAlertController()
                }
            // 초기 실행 시, 사진 촬영 권한 요청, 흭득 시 사용 가능
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraType, completionHandler: { granted in
                    if granted {
                        if self.openCamera(self.photoPickerViewController) {
                            // succeed
                        } else {
                            self.presentCameraAuthRequestAlertController()
                        }
                    } else {
                        self.presentCameraAuthRequestAlertController()
                    }
                })
            default: self.presentCameraAuthRequestAlertController()
            }
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

        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        photoSelectAlertController.addAction(takePictureAlertAction)
        photoSelectAlertController.addAction(getAlbumAlertAction)
        photoSelectAlertController.addAction(cancelAlertAction)
    }

    func presentPhotoSelectAlertController() {
        present(photoSelectAlertController, animated: true, completion: nil)
    }

    func presentPhotoAuthRequestAlertController() {
        presentAuthRequestAlertController(title: "사진첩 접근권한 필요", message: "사진첩을 실행하려면 접근권한 설정이 필요합니다.")
    }

    func presentCameraAuthRequestAlertController() {
        presentAuthRequestAlertController(title: "카메라 접근권한 필요", message: "카메라를 실행하려면 접근권한 설정이 필요합니다.")
    }

    // MARK: - Methods

    func checkAlbumAuthority(alertAction _: UIAlertAction) {}
}

extension PhotoAddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 만약 이미지가 성공적으로 선택 되었다면, 해당 이미지를 저장할 지를 묻는 AlertController를 띄운다.
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        selectedPhotoImageView.image = selectedImage
        closePhotoAlbum(photoPickerViewController)
        presentBasicAlertController(title: "사진을 저장 유무 확인", message: "사진을 저장하시겠습니까?") { isSucceed in
            if isSucceed {
                // 저장을 원하면 post처리를 진행한다.
                print("Ready To Post Photo Image!")
            } else {
                // 저장을 거부하면 일단 아무것도 실행 안함
                print("Cancel to save Photo Image!")
            }
        }
    }
}

extension PhotoAddViewController: UINavigationControllerDelegate {}
