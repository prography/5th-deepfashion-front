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
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var selectedPhotoImageView: UIImageView!

    @IBOutlet var classificationLabel: [UILabel]!

    // MARK: - Properties

    private lazy var photoSelectAlertController: UIAlertController = {
        let photoSelectAlertController = UIAlertController(title: "사진 추가방법 선택", message: "사진 추가방법을 선택하세요.", preferredStyle: .actionSheet)
        return photoSelectAlertController
    }()

    private lazy var photoPickerViewController: UIImagePickerController = {
        let photoPickerViewController = UIImagePickerController()
        photoPickerViewController.allowsEditing = true
        return photoPickerViewController
    }()

//    private lazy var yjModule: TorchModule = {
//        if let filePath = Bundle.main.path(forResource: "model", ofType: "pt"),
//            let module = TorchModule(fileAtPath: filePath) {
//            return module
//        } else {
//            fatalError("Can't find the model file!")
//        }
//    }()
//
//    private lazy var yjData: [String] = {
//        if let filePath = Bundle.main.path(forResource: "yjWords", ofType: "txt"),
//            let labels = try? String(contentsOfFile: filePath) {
//            return labels.components(separatedBy: .newlines)
//        } else {
//            fatalError("Can't find the text file!")
//        }
//    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        photoPickerViewController.delegate = self
        configureViewController()
        configurePhotoSelectAlertController()

//        let image = UIImage(named: "longJacket.png")!
//
//        let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
//        guard var pixelBuffer = resizedImage.normalized() else {
//            print("Fucking Asshole")
//            return
//        }
//
//        guard let outputs = yjModule.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
//            print("You Mother Fucker")
//            return
//        }
//
//        let zippedResults = zip(yjData.indices, outputs)
//        let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(3)
//        print("sortedResults: \(sortedResults)")
//        for (key,result) in sortedResults.enumerated() {
//            classificationLabel[key].text = yjData[result.0]
//        }
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }

    // MARK: Methods

    private func classificateImage(_: UIImage) {
//        let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
//        guard var pixelBuffer = resizedImage.normalized() else {
//            print("Fucking Asshole")
//            return
//        }
//
//        guard let outputs = yjModule.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
//            print("You Mother Fucker")
//            return
//        }
//
//        let zippedResults = zip(yjData.indices, outputs)
//        let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(3)
//        print("sortedResults: \(sortedResults)")
//        for (key,result) in sortedResults.enumerated() {
//            classificationLabel[key].text = yjData[result.0]
//        }
    }

    private func configurePhotoSelectAlertController() {
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
                        DispatchQueue.main.async {
                            self.openPhotoAlbum(self.photoPickerViewController)
                        }

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
                DispatchQueue.main.async {
                    self.openPhotoAlbum(self.photoPickerViewController)
                }
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

    private func presentPhotoAuthRequestAlertController() {
        presentAuthRequestAlertController(title: "사진첩 접근권한 필요", message: "사진첩을 실행하려면 접근권한 설정이 필요합니다.")
    }

    private func presentCameraAuthRequestAlertController() {
        presentAuthRequestAlertController(title: "카메라 접근권한 필요", message: "카메라를 실행하려면 접근권한 설정이 필요합니다.")
    }

    // MARK: - Methods

    private func presentAddFashionViewController(selectedImage: UIImage) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.addFashion) as? AddFashionViewController else {
            return
        }

        // 미리 해당 뷰컨에 필요한 이미지 추가 후 네비게이션 스택에 푸시
        viewController.selectedFashionImage = selectedImage
        navigationController?.pushViewController(viewController, animated: true)
    }

    func checkAlbumAuthority(alertAction _: UIAlertAction) {}
}

extension PhotoAddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        selectedPhotoImageView.image = selectedImage
        // 앨범을 닫는다.
        closePhotoAlbum(photoPickerViewController) { [weak self] in
            DispatchQueue.main.async {
                // 이미지를 분석한다.
                self?.classificateImage(selectedImage)
//                { [weak self] in
                ////                    //                    self?.presentAddFashionViewController(selectedImage: selectedImage)
//                }
            }
        }
    }
}

extension PhotoAddViewController: UINavigationControllerDelegate {}

extension PhotoAddViewController: UIViewControllerSetting {
    func configureViewController() {
        configureBasicTitle(ViewData.Title.MainTabBarView.photoAddView)
    }
}
