//
//  AddFashionViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionViewController: UIViewController {
    @IBOutlet var fashionNameTextField: UITextField!

    @IBOutlet var fashionTypeLabel: UILabel!
    @IBOutlet var fashionStyleLabel: UILabel!

    @IBOutlet var fashionImageView: UIImageView!
    var selectedFashionImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        fashionImageView.image = selectedFashionImage
    }

    @IBAction func addFashionButton(_: UIButton) {
        print("Add the Fashion!!")
        // 이미지 저장 준비가 되었다면 저장 후 해당 뷰컨트롤러를 pop 처리
        guard let selectedFashionImage = self.selectedFashionImage else { return }

        CommonUserData.shared.addUserImage(selectedFashionImage)

        let clotingData = UserClothingAPIData(style: 0, name: "clothing", color: "white", season: 0, part: 0, image: self.selectedFashionImage)
        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.styleImagePost) { _, isSucceed in
            if isSucceed {
                print("Clothing Post Succeed!!!")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Clothing Post Error!!!")
            }
        }

        print(CommonUserData.shared.userImage)
    }

    @IBAction func cancelButton(_: UIButton) {
        print("Cancel Adding the Fashion!!")

        navigationController?.popViewController(animated: true)
    }
}
