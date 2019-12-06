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

    var selectedFashionData = SelectedFashionData()

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

        fashionImageView.image = selectedFashionData.image

        configureFashionTypeSegmentedControl()
        configureFashionWeatherButtons()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        configureFashionStyleButton()
    }

    // MARK: Methods

    /// fashionNameTextField 값이 들어갔는지 확인하는 메서드
    private func isNameTextFieldEmpty() -> Bool {
        guard let nameText = fashionNameTextField.text else { return false }
        return nameText.trimmingCharacters(in: .whitespaces).isEmpty ? false : true
    }

    /// weatherButtons가 적어도 1개 이상 설정되어있는지 확인하는 메서드
    private func checkWeatherButtonSetting() -> Bool {
        for i in fashionWeatherButtons.indices {
            if fashionWeatherButtons[i].isSelected { return true }
        }
        return false
    }

    /// styleButton이 최소 1개 이상 설정되어있는지 확인하는 메서드
    private func checkStyleButtonSetting() -> Bool {
        return selectedFashionData.style.count != 0
    }

    private func configureFashionStyleButton() {
        if selectedFashionData.style.count == 0 { return }
        var fashionStyleButtonTitle = ""
        for i in selectedFashionData.style.indices {
            if selectedFashionData.style[i].1 == 1 {
                fashionStyleButtonTitle += "\(selectedFashionData.style[i].0)"
                if i != selectedFashionData.style.count - 1 { fashionStyleButtonTitle += " " }
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
        var selectedIndex = 0
        for i in fashionWeatherButtons.indices {
            if button == fashionWeatherButtons[i] {
                selectedIndex = i
                break
            }
        }

        if fashionWeatherButtons[selectedIndex].isSelected {
            selectedFashionData.weatherIndex[selectedIndex] = 0
            fashionWeatherButtons[selectedIndex].isSelected.toggle()
        } else {
            selectedFashionData.weatherIndex[selectedIndex] = 1
            fashionWeatherButtons[selectedIndex].isSelected.toggle()
        }
    }

    // MARK: - IBActions

    @IBAction func addFashionButton(_: UIButton) {
        print("Add the Fashion!!")

        // 이미지, 이름 셋팅
        guard let fashionImage = selectedFashionData.image,
            let fashionName = fashionNameTextField.text else { return }
        // 옷 타입, 스타일 셋팅
        let fashionType = selectedFashionData.typeIndex
        let fashionStyle = selectedFashionData.style
        // 옷 날씨타입 셋팅
        var fashionWeatherIndex = [Int]()
        for i in 0 ..< 4 {
            if selectedFashionData.weatherIndex[i] == 1 { fashionWeatherIndex.append(i) }
        }
        let clothingData = UserClothingData(image: fashionImage, name: fashionName, fashionType: fashionType, fashionWeahter: fashionWeatherIndex, fashionStyle: fashionStyle)
        CommonUserData.shared.addUserClothing(clothingData)
        print("now Adding Clothing Data : \(clothingData)")

        let clotingData = UserClothingAPIData(style: 0, name: "clothing", color: "white", season: 0, part: 0, images: selectedFashionData.image)
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

    @IBAction func editStyleButtonPressed(_: UIButton) {
        let storyboard = UIStoryboard(name: UIIdentifier.mainStoryboard, bundle: nil)
        guard let styleSelectViewController = storyboard.instantiateViewController(withIdentifier: UIIdentifier.ViewController.editStyle) as? EditStyleViewController else { return }
        styleSelectViewController.selectedStyle = selectedFashionData.style
        print(selectedFashionData.style)
        navigationController?.pushViewController(styleSelectViewController, animated: true)
    }

    @IBAction func cancelButton(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func fashionTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedFashionData.typeIndex = sender.selectedSegmentIndex
        print("now SelectedTypeIndex : \(selectedFashionData.typeIndex)")
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
