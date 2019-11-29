//
//  AddFashionViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionViewController: UIViewController {
    // MARK: - UIs

    @IBOutlet var fashionNameTextField: UITextField!

    @IBOutlet var fashionTypeButton: UIButton!

    @IBOutlet var fashionStyleLabel: UILabel!

    @IBOutlet var fashionImageView: UIImageView!

    var selectedFashionImage: UIImage?

    private let fashionTypeAlertController: TypeAlertController = {
        let fashionAlertController = TypeAlertController(title: "패션분류 선택", message: "패션 분류를 선택해주세요.", preferredStyle: .actionSheet)
        return fashionAlertController
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fashionTypeAlertController.fashionTypePickerView.delegate = self
        fashionTypeAlertController.fashionTypePickerView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        fashionImageView.image = selectedFashionImage
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: Methods

    private func presentFashionTypePickerView() {
        present(fashionTypeAlertController, animated: true)
    }

    // MARK: - IB Methods

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

    @IBAction func fashionTypeButtonPressed(_: UIButton) {
        presentFashionTypePickerView()
    }

    @IBAction func fashionStyleButtonPressed(_: UIButton) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        let styleSelectViewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.styleSelect)
        navigationController?.pushViewController(styleSelectViewController, animated: true)
    }

    @IBAction func cancelButton(_: UIButton) {
        print("Cancel Adding the Fashion!!")

        navigationController?.popViewController(animated: true)
    }
}

extension AddFashionViewController: UIPickerViewDelegate {
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        fashionTypeButton.setTitle("\(ViewData.Title.fashionType[row])", for: .normal)
    }
}

extension AddFashionViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return ViewData.Title.fashionType.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return "\(ViewData.Title.fashionType[row])"
    }
}
