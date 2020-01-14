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
            isImageSelected = true
            photoPickerViewController.dismiss(animated: true) {
                DispatchQueue.main.async {
                    // 3) 이미지를 분석, 분석 결과를 저장한다.
                    self.classificateImage(newImage) { deepResult in
                        // 라벨을 변화 시킨다.
                        guard let clothingImage = self.selectedClothingImage else { return }
                        if self.isImageSelected {
                            self.isImageSelected = false
                            self.presentEditClothinngViewController(selectedImage: clothingImage, deepResult: deepResult)
                        }
                    }
                }
            }
        }
    }

    private var isImageSelected = false {
        didSet {
            if isImageSelected {
                configureLayoutWithDeepLearningStatus()
            } else {
                configureLayoutWithInitStatus()
            }
        }
    }

    // MARK: - Add DeepLearning Module

    // pt파일을 불러와 TorchModule을 준비한다.

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
//        configureEmptyTitle()
//        navigationController?.navigationBar.isHidden = false
//        configureBasicTitle(ViewData.Title.MainTabBarView.photoAdd)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        endIgnoringInteractionEvents()
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        isImageSelected = false
    }

    // MARK: Methods

    // MARK: - DeepLearning Classification Method

    /// 이미지를 판별하는 과정이 진행되는 메서드
    private func classificateImage(_:
        UIImage, completion: @escaping ([Int]) -> Void) {
        /*
         let yjModule: TorchModule = {
             // 파일경로가 정상인지 확인 한 후 정상이면 해당 파일경로의 pt파일을 TorchModule에서 읽는다.
             if let filePath = Bundle.main.path(forResource: "fashModel2", ofType: "pt"),
                 let module = TorchModule(fileAtPath: filePath) {
                 return module
             } else {
                 // pt파일을 읽지 못하면 해당 행 실행
                 fatalError("Can't find the model file!")
             }
         }()

         // 식별하려는 이미지의 사이즈를 224x224로 변환한다.
         let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
         // 224x224 크기의 리사이즈 된 이미지를 Float32 배열로 변환하여 pixelBuffer에 저장한다.
         guard var pixelBuffer = resizedImage.normalized() else {
             debugPrint("pixelBuffer Error!")
             completion([1, 1, 1, 1])
             return
         }

         // 이미지를 배열로변환 한 뒤 해당 배열에 TorchModule의 predict메서드를 이용해 classification을 진행한다.
         // 만약 classification 이 제대로 되지 않으면 else 로 빠져나가 classificateImage 메서드가 종료된다.
         guard let outputs = yjModule.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else {
             completion([1, 1, 1, 1])
             debugPrint("predict Method Error!")
             return
         }

         debugPrint(outputs) // 딥러닝 결과 파트 별 최댓값 인덱스 출력
         let deepOutputList = outputs.map { Int(truncating: $0) }
         // escaping 으로 classificateImage 메서드의 종료 시 해당 메서드 호출 휘치에 알림
         completion(deepOutputList)
         */
        completion([1, 1, 1, 1])
    }

    private func configureImageView() {
        let imageTapGestureRecognizer = UITapGestureRecognizer()
        imageTapGestureRecognizer.addTarget(self, action: #selector(clothingImageViewPressed(_:)))
        clothingImageView.addGestureRecognizer(imageTapGestureRecognizer)
        clothingImageView.layer.borderWidth = 3
        clothingImageView.layer.borderColor = ViewData.Color.border
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

//    private func configureSaveClothingButton() {
//        saveClothingButton.titleLabel?.font = UIFont.mainFont(displaySize: 18)
//        saveClothingButton.setTitle("옷 추가하기", for: .normal)
//        saveClothingButton.configureDisabledButton()
//    }

    private func configurePhotoSelectAlertController() {
        let takePictureAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { _ in
            let cameraType = AVMediaType.video
            let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: cameraType)
            switch cameraAuthStatus {
            case .authorized:
                self.openCamera(self.photoPickerViewController)
            // 초기 실행 시, 사진 촬영 권한 요청, 흭득 시 사용 가능
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraType, completionHandler: { granted in
                    if granted {
                        self.openCamera(self.photoPickerViewController)
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
                debugPrint("notDetermined, 아직 응답하지 않음")
                // 처음 응답이 없었을때 권한요청을 한다. 권한허용을 했다면, 앨범을 불러온다. 거절되면 빈 셀을 띄운다.
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        debugPrint("사용자 측 권한 허용 선택")
                        // 이때는 앨범 리스트를 연다.
                        DispatchQueue.main.async {
                            self.openPhotoAlbum(self.photoPickerViewController)
                        }
                        debugPrint("Present the Album List")
                    default:
                        debugPrint("사용자 불허")
                    }
                }
            case .restricted, .denied:
                self.presentPhotoAuthRequestAlertController()
            case .authorized:
                debugPrint("authorized, 접근 승인")
                // 이때는 앨범을 열어준다.
                DispatchQueue.main.async {
                    self.openPhotoAlbum(self.photoPickerViewController)
                }
            @unknown default:
                debugPrint("unknown default error")
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
        DispatchQueue.main.async {
            self.presentAuthRequestAlertController(title: "사진첩 접근권한 필요", message: "옷 사진 등록을 위해 앨범 접근권한이 필요합니다.")
        }
    }

    func configureLayoutWithInitStatus() {
        for i in classificationLabel.indices {
            classificationLabel[i].isHidden = true
        }

        classificationLabel[0].text = "앨범이나 사진촬영으로 옷을 추가하세요."
        classificationLabel[0].isHidden = false
//        saveClothingButton.isEnabled = false
        clothingImageView.image = UIImage(named: AssetIdentifier.Image.addClothing)
    }

    private func configureLayoutWithDeepLearningStatus() {
        for i in classificationLabel.indices {
            classificationLabel[i].isHidden = false
        }

        // 추출한 딥러닝 결과를 라벨로 보여준다.
        classificationLabel[0].text = ""
        classificationLabel[1].text = ""
        classificationLabel[2].text = ""
//        saveClothingButton.configureEnabledButton()
    }

    private func presentCameraAuthRequestAlertController() {
        DispatchQueue.main.async {
            self.presentAuthRequestAlertController(title: "카메라 접근권한 필요", message: "옷 사진 등록을 위해 카메라 접근권한이 필요합니다.")
        }
    }

    // MARK: - Methods

    private func presentEditClothinngViewController(selectedImage: UIImage, deepResult: [Int]) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let editClothingViewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editClothing) as? EditClothingViewController else {
            return
        }

        // 미리 해당 뷰컨에 필요한 이미지 추가 후 네비게이션 스택에 푸시
        editClothingViewController.selectedClothingData.image = selectedImage
        editClothingViewController.deepResultList = deepResult
        navigationController?.pushViewController(editClothingViewController, animated: true)
    }

    private func checkAlbumAuthority(alertAction _: UIAlertAction) {}

    @objc func clothingImageViewPressed(_: UIImageView) {
        presentPhotoSelectAlertController()
    }

//    @IBAction func saveClothingButtonPressed(_: UIButton) {
//        // 커스텀 패션 설정 창을 띄운다.
//
//    }

    @IBAction func unwindToClothingAddView(_: UIStoryboardSegue) {
        guard let tabBarController = tabBarController as? MainTabBarController else { return }
        UserCommonData.shared.setIsNeedToUpdateClothingTrue()
        isImageSelected = true
        tabBarController.presentToastMessage("해당 옷이 추가되었습니다!")
        configureLayoutWithInitStatus()

        RequestAPI.shared.getAPIData(APIMode: .getClothing, type: ClothingAPIDataList.self) { networkError, clothingDataList in

            DispatchQueue.main.async {
                guard let tabBarController = self.tabBarController as? MainTabBarController,
                    let clothingDataList = clothingDataList else { return }
                if networkError != nil {
                    UserCommonData.shared.configureClothingData(clothingDataList)
                    CodiListGenerator.shared.getNowCodiDataSet()
                    tabBarController.reloadRecommendCollectionView(clothingDataList)
                    UserCommonData.shared.setIsNeedToUpdateClothingFalse()
                } else {
                    tabBarController.presentToastMessage("옷 데이터 업데이트에 실패했습니다.")
                }
            }
        }
    }
}

extension ClothingAddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }

//        clothingImageView.image = selectedImage
        selectedClothingImage = selectedImage
//        guard let clothingImage = clothingImageView.image else { return }
    }
}

extension ClothingAddViewController: UINavigationControllerDelegate {}

extension ClothingAddViewController: UIViewControllerSetting {
    func configureViewController() {
        configurePhotoSelectAlertController()
        configureImageView()
//        configureSaveClothingButton()
        configureClassificationLabel()
        photoPickerViewController.delegate = self
    }
}
