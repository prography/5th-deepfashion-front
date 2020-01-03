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

class ClothingAddViewController: UIViewController {
    // MARK: UIs

    // MARK: - IBOutlet

    @IBOutlet var clothingImageView: UIImageView!
    @IBOutlet var classificationLabel: [UILabel]!
    @IBOutlet var saveClothingButton: UIButton!

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

    private var selectedClothingImage: UIImage? {
        willSet {
            guard let newImage = newValue else { return }
            // 1) 사진 촬영 or 앨범을 선택해서 이미지를 받아온 후
            // 2) 앨범 or 화면 화면을 닫는다.
            photoPickerViewController.dismiss(animated: true) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    // 3) 이미지를 분석, 분석 결과를 저장한다.
                    self?.classificateImage(newImage) { [weak self] in
                        // 라벨을 변화 시킨다.
                        self?.isImageSelected = true
                    }
                }
            }
        }
    }

    private var isImageSelected = false {
        didSet {
            saveClothingButton.isEnabled = isImageSelected

            if isImageSelected {
                configureLayoutWithDeepLearningStatus()
            } else {
                configureLayoutWithInitStatus()
            }
        }
    }

    // MARK: - Add DeepLearning Module

    /*
     // pt파일을 불러와 TorchModule을 준비한다.
     lazy var yjModule: TorchModule = {
         // 파일경로가 정상인지 확인 한 후 정상이면 해당 파일경로의 pt파일을 TorchModule에서 읽는다.
         if let filePath = Bundle.main.path(forResource: "combine", ofType: "pt"),
             let module = TorchModule(fileAtPath: filePath) {
             return module
         } else {
             // pt파일을 읽지 못하면 해당 행 실행
             fatalError("Can't find the model file!")
         }
     }()
     */

    // txt데이터를 불러와 문자열 배열로 준비한다.
//    private let yjData: [String] = {
//        // 파일경로가 정상인지 확인 한 후 정상이면 해당 파일경로의 txt파일을 TorchModule에서 읽는다.
//        if let filePath = Bundle.main.path(forResource: "combine", ofType: "txt"),
//            let labels = try? String(contentsOfFile: filePath) {
//            return labels.components(separatedBy: .newlines)
//        } else {
//            // txt파일을 읽지 못하면 해당 행 실행
//            fatalError("Can't find the text file!")
//        }
//    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
        configureBasicTitle(ViewData.Title.MainTabBarView.photoAdd)
    }

    // MARK: Methods

    // MARK: - DeepLearning Classification Method

    /// 이미지를 판별하는 과정이 진행되는 메서드
    private func classificateImage(_:
        UIImage, completion: @escaping () -> Void) {
        /*
         // 식별하려는 이미지의 사이즈를 224x224로 변환한다.
         let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
         // 224x224 크기의 리사이즈 된 이미지를 Float32 배열로 변환하여 pixelBuffer에 저장한다.
         guard var pixelBuffer = resizedImage.normalized() else {
             return
         }

         // 이미지를 배열로변환 한 뒤 해당 배열에 TorchModule의 predict메서드를 이용해 classification을 진행한다.
         // 만약 classification 이 제대로 되지 않으면 else 로 빠져나가 classificateImage 메서드가 종료된다.
         guard let outputs = yjModule.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
             return
         }

         print(outputs) // 딥러닝 결과 파트 별 최댓값 인덱스 출력
         */

        // escaping 으로 classificateImage 메서드의 종료 시 해당 메서드 호출 휘치에 알림
        completion()
    }

    private func configureImageView() {
        let imageTapGestureRecognizer = UITapGestureRecognizer()
        imageTapGestureRecognizer.addTarget(self, action: #selector(clothingImageViewPressed(_:)))
        clothingImageView.addGestureRecognizer(imageTapGestureRecognizer)
        clothingImageView.layer.borderWidth = 3
        clothingImageView.layer.borderColor = ViewData.Color.borderColor
        clothingImageView.layer.cornerRadius = 10
    }

    private func configureClassificationLabel() {
        for i in classificationLabel.indices {
            classificationLabel[i].adjustsFontSizeToFitWidth = true
            classificationLabel[i].font = UIFont.mainFont(displaySize: 13)
            classificationLabel[i].textColor = ColorList.brownish
            classificationLabel[i].isHidden = true
        }

        classificationLabel[0].isHidden = false
    }

    private func configureSaveClothingButton() {
        saveClothingButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
        saveClothingButton.setTitle("옷 추가하기", for: .normal)
        saveClothingButton.configureDisabledButton()
    }

    private func configurePhotoSelectAlertController() {
        let takePictureAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { _ in
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
            @unknown default:
                fatalError()
            }
        })

        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        photoSelectAlertController.addAction(takePictureAlertAction)
        photoSelectAlertController.addAction(getAlbumAlertAction)
        photoSelectAlertController.addAction(cancelAlertAction)
    }

    private func presentPhotoSelectAlertController() {
        present(photoSelectAlertController, animated: true, completion: nil)
    }

    private func presentPhotoAuthRequestAlertController() {
        presentAuthRequestAlertController(title: "사진첩 접근권한 필요", message: "사진첩을 실행하려면 접근권한 설정이 필요합니다.")
    }

    func configureLayoutWithInitStatus() {
        for i in classificationLabel.indices {
            classificationLabel[i].isHidden = true
        }

        classificationLabel[0].text = "상단 이미지를 탭해서 옷을 추가하세요"
        classificationLabel[0].isHidden = false
        saveClothingButton.isEnabled = false
        clothingImageView.image = UIImage(named: AssetIdentifier.Image.addClothing)
    }

    private func configureLayoutWithDeepLearningStatus() {
        for i in classificationLabel.indices {
            classificationLabel[i].isHidden = false
        }

        // 추출한 딥러닝 결과를 라벨로 보여준다.
        classificationLabel[0].text = "옷 이름 : XXX"
        classificationLabel[1].text = "옷 분류 : XXX"
        classificationLabel[2].text = "#xxx #xxx #xxx"
        saveClothingButton.configureEnabledButton()
    }

    private func presentCameraAuthRequestAlertController() {
        presentAuthRequestAlertController(title: "카메라 접근권한 필요", message: "카메라를 실행하려면 접근권한 설정이 필요합니다.")
    }

    // MARK: - Methods

    private func presentAddFashionViewController(selectedImage: UIImage) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editClothing) as? EditClothingViewController else {
            return
        }

        // 미리 해당 뷰컨에 필요한 이미지 추가 후 네비게이션 스택에 푸시
        viewController.selectedClothingData.image = selectedImage
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func checkAlbumAuthority(alertAction _: UIAlertAction) {}

    @objc func clothingImageViewPressed(_: UIImageView) {
        presentPhotoSelectAlertController()
    }

    @IBAction func saveClothingButtonPressed(_: UIButton) {
        // 커스텀 패션 설정 창을 띄운다.
        guard let clothingImage = clothingImageView.image else { return }

        presentAddFashionViewController(selectedImage: clothingImage)
    }

    @IBAction func unwindToClothingAddView(_: UIStoryboardSegue) {
        guard let tabBarController = tabBarController as? MainTabBarController else { return }
        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
        ToastView.shared.presentShortMessage(tabBarController.view, message: "해당 옷이 추가되었습니다!")
        configureLayoutWithInitStatus()

        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in

            DispatchQueue.main.async {
                guard let tabBarController = self.tabBarController as? MainTabBarController,
                    let clothingDataList = clothingDataList else { return }
                if networkError != nil {
                    UserCommonData.shared.configureClothingData(clothingDataList)
                    CodiListGenerator.shared.getNowCodiDataSet(clothingDataList)
                    tabBarController.reloadRecommendCollectionView(clothingDataList)
                } else {
                    ToastView.shared.presentShortMessage(tabBarController.view, message: "옷 데이터 업데이트에 실패했습니다.")
                }
            }
        }
    }
}

extension ClothingAddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        clothingImageView.image = selectedImage
        selectedClothingImage = selectedImage
    }
}

extension ClothingAddViewController: UINavigationControllerDelegate {}

extension ClothingAddViewController: UIViewControllerSetting {
    func configureViewController() {
        configurePhotoSelectAlertController()
        configureImageView()
        configureSaveClothingButton()
        configureClassificationLabel()
        photoPickerViewController.delegate = self
    }
}
