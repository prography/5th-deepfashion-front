//
//  AddPhotoViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/15.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class PhotoAddViewController: UIViewController {
    // MARK: - Properties

    private let photoSelectAlertController: UIAlertController = {
        let photoSelectAlertController = UIAlertController(title: "사진 추가방법 선택", message: "사진 추가방법을 선택하세요.", preferredStyle: .actionSheet)
        let takePictureAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { _ in
            print("사진 찍기 클릭")
            // 초기 실행 시, 사진 촬영 권한 요청, 흭득 시 사용 가능
        }
        let getAlbumAlertAction = UIAlertAction(title: "앨범 사진 가져오기", style: .default) { _ in
            print("앨범 사진 가져오기")
            // 초기 실행 시, 앨범 권한을 요청, 흭득 시 사용 가능
        }
        photoSelectAlertController.addAction(takePictureAlertAction)
        photoSelectAlertController.addAction(getAlbumAlertAction)
        return photoSelectAlertController
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func presentPhotoSelectAlertController() {
        present(photoSelectAlertController, animated: true, completion: nil)
    }
}
