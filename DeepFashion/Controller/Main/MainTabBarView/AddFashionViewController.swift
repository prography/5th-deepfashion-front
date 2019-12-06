//
//  AddFashionViewController.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/11/27.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

class AddFashionViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var fashionNameTextField: UITextField!

    @IBOutlet var fashionStyleButton: UIButton!

    @IBOutlet var fashionImageView: UIImageView!

    @IBOutlet var fashionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var fashionWeatherButtons: [UIButton]!

    // MARK: Properties

    var selectedFashionImage: UIImage?
    var selectedFashionStyle = [(String, Int)]()
    var selectedFashionTypeIndex = 0
    var selectedWeatherIndex: Set<Int> = [0]

    private let fashionTypeAlertController: TypeAlertController = {
        let fashionAlertController = TypeAlertController(title: "패션분류 선택", message: "패션 분류를 선택해주세요.", preferredStyle: .actionSheet)
        return fashionAlertController
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fashionTypeAlertController.fashionTypePickerView.dataSource = self
        fashionNameTextField.delegate = self
        navigationController?.navigationBar.isHidden = true

        fashionImageView.image = selectedFashionImage

        configureFashionTypeSegmentedControl()
        configureFashionWeatherButtons()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureFashionStyleButton()
    }

    // MARK: Methods

    private func configureFashionStyleButton() {
        if selectedFashionStyle.count == 0 { return }
        var fashionStyleButtonTitle = ""
        for i in selectedFashionStyle.indices {
            if selectedFashionStyle[i].1 == 1 {
                fashionStyleButtonTitle += "\(selectedFashionStyle[i].0)"
                if i != selectedFashionStyle.count - 1 { fashionStyleButtonTitle += " " }
            }
        }

        fashionStyleButton.setTitle("\(fashionStyleButtonTitle)", for: .normal)
    }

    private func configureFashionTypeSegmentedControl() {
        // 초기 선택 인덱스를 설정
        fashionTypeSegmentedControl.selectedSegmentIndex = 0
    }

    private func configureFashionWeatherButtons() {
        for i in fashionWeatherButtons.indices {
            if i == 0 { fashionWeatherButtons[i].isSelected = true }
            else { fashionWeatherButtons[i].isSelected = false }
        }
    }

    private func selectFashionWeatherButton(_ button: UIButton) {
        var selectedButton = UIButton()
        for i in fashionWeatherButtons.indices {
            if button == fashionWeatherButtons[i] {
                selectedButton = button
                break
            }
        }
        guard let selectedText = selectedButton.titleLabel?.text else { return }
        print("nowSelected WeatherButton Index : \(selectedText)")
    }

//    private func presentFashionTypePickerView() {
//        present(fashionTypeAlertController, animated: true)
//    }

    // MARK: - IBActions

    @IBAction func addFashionButton(_: UIButton) {
        print("Add the Fashion!!")
        // 이미지 저장 준비가 되었다면 저장 후 해당 뷰컨트롤러를 pop 처리
        guard let selectedFashionImage = self.selectedFashionImage,
            let selectedFashionName = fashionNameTextField.text else { return }

//        guard let nowfashionType = fashionTypeButton.titleLabel?.text else { return }

//        let clothingData = UserClothingData(image: selectedFashionImage, name: selectedFashionName, fashionType: nowfashionType, fashionStyle: selectedFashionStyle)
//        CommonUserData.shared.addUserClothing(clothingData)
//
//        print("now Adding Clothing Data : \(clothingData)")
        let clotingData = UserClothingAPIData(style: 0, name: "clothing", color: "white", season: 0, part: 0, images: self.selectedFashionImage)
        RequestAPI.shared.postAPIData(userData: clotingData, APIMode: APIPostMode.styleImagePost) { _, isSucceed in
            if isSucceed {
                print("Clothing Post Succeed!!!")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Clothing Post Error!!!")
                print("하지만 사진 등록 테스트를 위해 이전 뷰로 돌아갑니다..")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

        print(CommonUserData.shared.userClothingList)
    }

//    @IBAction func fashionTypeButtonPressed(_: UIButton) {
//        presentFashionTypePickerView()
//    }

    @IBAction func fashionStyleButtonPressed(_: UIButton) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        let styleSelectViewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.styleSelect)
        navigationController?.pushViewController(styleSelectViewController, animated: true)
    }

    @IBAction func cancelButton(_: UIButton) {
        print("Cancel Adding the Fashion!!")

        navigationController?.popViewController(animated: true)
    }

    @IBAction func fashionTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionTypeIndex = sender.selectedSegmentIndex
        print("now SelectedTypeIndex : \(selectedFashionTypeIndex)")
    }

    @IBAction func fashionWeatherButtonPressed(_ sender: UIButton) {
        selectFashionWeatherButton(sender)
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

extension AddFashionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
